require "rails_helper"

RSpec.describe AnamnesisSheetsController, type: :controller do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let!(:anamnesis_sheet) { create(:anamnesis_sheet, customer_id: customer.id) }

  describe "when logged in" do
    before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

    context "GET #index" do
      before { get :index }

      it { expect(response).to be_successful }
      it { expect(assigns(:anamnesis_sheets)).to include anamnesis_sheet }
    end

    context "GET #show" do
      before { get :show, params: { id: anamnesis_sheet.id } }

      it { expect(assigns(:anamnesis_sheet)).to eq anamnesis_sheet }
      it { expect(response).to be_successful }
    end

    context "GET #edit" do
      before { get :edit, params: { id: anamnesis_sheet.id } }

      it { expect(assigns(:anamnesis_sheet)).to eq anamnesis_sheet }
      it { expect(response).to be_successful }
    end

    context "PUT #update" do
      before { put :update, params: { id: anamnesis_sheet.id, anamnesis_sheet: new_attributes } }

      context "with valid params" do
        let(:new_attributes) { { title: "New Title" } }

        it { expect { anamnesis_sheet.reload }.to change { anamnesis_sheet.title }.from("Title").to("New Title") }
        it { expect(flash[:notice]).to eq "Anamnesis sheet was successfully updated." }
      end

      context "with invalid params" do
        let(:new_attributes) { { title: nil } }

        it { expect { anamnesis_sheet.reload }.not_to change { anamnesis_sheet.title } }
      end
    end

    context "DELETE #destroy" do
      context "changes the count from 1 to 0" do
        it { expect { delete :destroy, params: { id: anamnesis_sheet.id } }.to change(AnamnesisSheet, :count).from(1).to(0) }
      end

      context "returns flash message" do
        before { delete :destroy, params: { id: anamnesis_sheet.id } }
        it { expect(flash[:notice]).to eq "Anamnesis sheet was successfully destroyed." }
      end
    end

    describe "GET #new" do
      let(:token) { JsonWebToken.encode }

      context "with jwt token" do
        before { get :new, params: { token: token } }

        it { expect(response).to be_successful }
        it { expect(response).to render_template :new }
      end

      context "without jwt token" do
        before { get :new }

        it { expect(response).not_to be_successful }
        it { expect(flash[:alert]).to eq "Token não encontrado." }
      end

      context "with expired jwt token" do
        let(:expired_token) { "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NTcxMTQxOTd9.c2nerc6H6L8ZzsC1H-r8vcYCGx56AnQPSVIINIylsPo" }

        before { get :new, params: { token: expired_token } }

        it { expect(response).not_to be_successful }
        it { expect(flash[:alert]).to eq "Token inválido ou expirado." }
      end

      context "with wrong jwt token" do
        let(:invalid_token) { "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NTcxMTQxOTd9.c2nerc6H6L8ZzsC1H-AnQPSVIINIylsPo123123" }

        before { get :new, params: { token: invalid_token } }

        it { expect(response).not_to be_successful }
        it { expect(flash[:alert]).to eq "Token inválido ou expirado." }
      end
    end

    describe "POST #create" do
      let(:token) { JsonWebToken.encode }
      let(:invalid_token) { "invalid " }
      let(:valid_attributes) { { title: "Title" } }
      let(:invalid_attributes) { { title: nil } }

      context "with valid params and token" do
        it "creates a new AnamnesisSheet" do
          expect { post :create, params: { anamnesis_sheet: valid_attributes, token: token } }.to change(AnamnesisSheet, :count).by(1)
        end

        it "redirects to the created anamnesis_sheet" do
          post :create, params: { anamnesis_sheet: valid_attributes, token: token }

          expect(response).to redirect_to(AnamnesisSheet.last)
        end
      end

      context "with invalid params" do
        before { post :create, params: { anamnesis_sheet: invalid_attributes } }

        it { expect(response).not_to be_successful }
      end

      context "with invalid token" do
        it { expect { post :create, params: { anamnesis_sheet: valid_attributes } }.not_to change(AnamnesisSheet, :count) }
        it { expect { post :create, params: { anamnesis_sheet: valid_attributes, token: invalid_token } }.not_to change(AnamnesisSheet, :count) }
      end
    end

    context "GET #qrcode_link_generate" do
      before { get :qrcode_link_generate }

      it { expect(response).to redirect_to anamnesis_sheets_path }
      it { expect(flash[:notice]).to eq "Link e Qrcode criados com sucesso." }
    end
  end

  describe "when not logged in" do
    before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

    context "GET #index" do
      before { get :index }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "GET #show" do
      before { get :show, params: { id: anamnesis_sheet.id } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "GET #edit" do
      before { get :edit, params: { id: anamnesis_sheet.id } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "PUT #update" do
      let(:new_attributes) { { title: "New Title" } }

      before { put :update, params: { id: anamnesis_sheet.id, anamnesis_sheet: new_attributes } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "DELETE #destroy" do
      before { delete :destroy, params: { id: anamnesis_sheet.id } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "GET #new" do
      let(:token) { "got_authenticated_error_before" }

      before { get :new, params: { token: token } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "POST #create" do
      let(:valid_attributes) { { title: "Title" } }
      let(:token) { "got_authenticated_error_before" }

      before { post :create, params: { anamnesis_sheet: valid_attributes, token: token } }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end

    context "GET #qrcode_link_generate" do
      before { get :qrcode_link_generate }

      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
