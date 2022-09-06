require 'rails_helper'

RSpec.describe GiftCardsController, type: :controller do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let(:gift_card) { create(:gift_card, customer_id: customer.id) }

  let(:new_attributes) { { name: "New Name" } }
  let(:valid_attributes) { { name: "Some Name", price: 123.12, customer_id: customer.id } }
  let(:invalid_attributes) { { customer: nil } }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe "GET /index" do
    before { get :index }

    it { expect(response).to render_template(:index) }
    it { expect(response).to be_successful }
    it { expect(assigns(:gift_cards)).to include gift_card }
  end

  describe "GET /new" do
    context "when authenticated" do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:gift_card)).to be_a_new GiftCard }
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :new }

      it { expect(response).not_to render_template(:new) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "GET /show" do
    context "when authenticated" do
      before do
        get :show, params: { id: gift_card }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:gift_card)).to eq gift_card }
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        get :show, params: { id: gift_card }
      end

      it { expect(response).not_to render_template(:show) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "GET /edit" do
    context "when authenticated" do
      before do
        get :edit, params: { id: gift_card }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:gift_card)).to eq gift_card }
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        get :edit, params: { id: gift_card }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "POST /create" do
    context "when authenticated" do
      context "with valid parameters" do
        it "creates a new gift card" do
          expect { post :create, params: { gift_card: valid_attributes } }.to change(GiftCard, :count).by(01)
        end

        it "returns the successfull message" do
          post :create, params: { gift_card: valid_attributes }
          expect(flash[:notice]).to eq "Vale Presente criado com sucesso."
        end

        it "redirects to the gift card view" do
          post :create, params: { gift_card: valid_attributes }
          expect(response).to redirect_to(gift_card_url(GiftCard.last))
        end
      end

      context "with invalid parameters" do
        before { post :create, params: { gift_card: invalid_attributes } }
        it "does not create a new gift card" do
          expect { post :create, params: { gift_card: invalid_attributes } }.not_to change(GiftCard, :count)
        end

        it "should return :unprocessable_entity 422" do
          expect(response.status).to eq 422
        end

        it "display the 'new' template" do
          expect(response).not_to be_successful
          expect(response).to render_template :new
        end
      end
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { post :create, params: { gift_card: valid_attributes } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "PATCH /update" do
    context "when authenticated" do
      context "with valid parameters" do
        before do
          patch :update, params: { id: gift_card, gift_card: new_attributes }
        end

        it "should assigns the gift card" do
          expect(assigns(:gift_card)).to eq gift_card
        end

        it "updates the requested gift card" do
          expect { gift_card.reload }.to change { gift_card.name }.from("Gift Card Name").to("New Name")
        end

        it "redirects to the gift card" do
          expect(gift_card.reload).to redirect_to(gift_card_url(gift_card))
        end

        it "returns a flash message" do
          expect(flash[:notice]).to eq "Vale Presente atualizado com sucesso."
        end
      end

      context "with invalid parameters" do
        before do
          patch :update, params: { id: gift_card, gift_card: { customer_id: nil } }
        end

        it "should return :unprocessable_entity 422" do
          expect(response.status).to eq 422
        end

        it "display the 'edit' template" do
          expect(response).not_to be_successful
          expect(response).to render_template :edit
        end
      end
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        patch :update, params: { id: gift_card, gift_card: new_attributes }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "DELETE /destroy" do
    before { gift_card.save }

    describe "when authenticated" do
      it "destroys the requested gift card" do
        expect { delete :destroy, params: { id: gift_card } }.to change(GiftCard, :count).by(-1)
      end

      it "returns the successfull message" do
        delete :destroy, params: { id: gift_card }
        expect(flash[:notice]).to eq "Vale Presente removido com sucesso."
      end

      it "redirects to the gift card view" do
        delete :destroy, params: { id: gift_card }
        expect(response).to redirect_to(gift_cards_url)
      end
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        delete :destroy, params: { id: gift_card }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
