require "rails_helper"

RSpec.describe AnamnesisSheetsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let!(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let!(:anamnesis_sheet) { create(:anamnesis_sheet, customer_id: customer.id) }

  describe "when logged in" do
    before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

    context "GET #show" do
      before { get :show, params: { id: anamnesis_sheet.id, customer_id: customer.id } }

      it { expect(assigns(:anamnesis_sheet)).to eq anamnesis_sheet }
      it { expect(response).to be_successful }
    end

    context "DELETE #destroy" do
      context "changes the count from 1 to 0" do
        it { expect { delete :destroy, params: { id: anamnesis_sheet.id, customer_id: customer.id } }.to change(AnamnesisSheet, :count).from(1).to(0) }
      end

      context "returns flash message" do
        before { delete :destroy, params: { id: anamnesis_sheet.id, customer_id: customer.id } }
        it { expect(flash[:notice]).to eq "Ficha de Anamnese removida com sucesso." }
      end
    end

    describe "GET #new" do
      let!(:token) { JsonWebToken.encode(customer.id) }

      context "with jwt token" do

        before { get :new, params: { customer_id: customer.id, token: token } }

        it { expect(response).to be_successful }
        it { expect(response).to render_template :new }
        it { expect(assigns(:token)).to eq token }
      end

      context "without jwt token will generate new token" do
        before { get :new, params: { customer_id: customer.id } }

        it { expect(response).to be_successful }
        it { expect(response.body).to include(new_customer_anamnesis_sheet_url(customer, token: token)) }
        it { expect(assigns(:token)).to eq token }
      end

      context "with expired jwt token" do
        let(:expired_token) { "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NTcxMTQxOTd9.c2nerc6H6L8ZzsC1H-r8vcYCGx56AnQPSVIINIylsPo" }

        before { get :new, params: { customer_id: customer.id, token: expired_token } }

        it { expect(response).not_to be_successful }
        it { expect(flash[:alert]).to eq "Token inválido ou expirado." }
      end

      context "with wrong jwt token" do
        let(:invalid_token) { "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NTcxMTQxOTd9.c2nerc6H6L8ZzsC1H-AnQPSVIINIylsPo123123" }

        before { get :new, params: { customer_id: customer.id, token: invalid_token } }

        it { expect(response).not_to be_successful }
        it { expect(flash[:alert]).to eq "Token inválido ou expirado." }
      end
    end

    describe "POST #create" do
      let(:token) { JsonWebToken.encode(customer.id) }
      let(:invalid_token) { "invalid" }
      let(:valid_attributes) { { recent_cirurgy_details: "some recent_cirurgy_details text" } }
      let(:invalid_attributes) { { customer_id: nil } }

      context "with valid params and token" do
        it "creates a new AnamnesisSheet" do
          expect { post :create, params: { anamnesis_sheet: valid_attributes, token: token, customer_id: customer.id } }.to change(AnamnesisSheet, :count).by(1)
        end

        it "redirects to the created anamnesis_sheet" do
          post :create, params: { anamnesis_sheet: valid_attributes, token: token, customer_id: customer.id }

          expect(response).to redirect_to(customer_url(customer))
        end
      end

      context "with invalid params" do
        before { post :create, params: { customer_id: customer.id, anamnesis_sheet: invalid_attributes, token: token } }

        it { expect(response).not_to be_successful }
      end

      context "with invalid token" do
        it { expect { post :create, params: { customer_id: customer.id, anamnesis_sheet: valid_attributes, token: invalid_token } }.not_to change(AnamnesisSheet, :count) }
      end
    end
  end

  describe "when not logged in" do
    before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

    context "GET #show" do
      before { get :show, params: { customer_id: customer.id, id: anamnesis_sheet.id } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "DELETE #destroy" do
      before { delete :destroy, params: { customer_id: customer.id, id: anamnesis_sheet.id } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "POST #create" do
      let(:valid_attributes) { { title: "Title" } }
      let(:token) { "got_authenticated_error_before" }

      before { post :create, params: { customer_id: customer.id, anamnesis_sheet: valid_attributes, token: token } }

      it { expect(response).to redirect_to customer_url(customer) }
      it { expect(flash[:alert]).to eq "Token inválido ou expirado." }
    end
  end
end
