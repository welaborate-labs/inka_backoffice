require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, :with_avatar) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:service) { create(:service, professional: professional) }
  let(:product) { create(:product) }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  let(:new_attributes) { { name: 'New name' } }
  let(:valid_attributes) { { name: 'Some name', sku: 'SKUCode', unit: 'l' } }
  let(:invalid_attributes) { { name: nil } }

  describe 'GET /index' do
    context 'when authenticated' do
      before { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:products)).to include product }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :index }

      it { expect(response).not_to render_template(:index) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:product)).to be_a_new Product }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :new }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before { get :show, params: { id: product } }

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:product)).to eq product }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :show, params: { id: product } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before { get :edit, params: { id: product } }

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:product)).to eq product }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :edit, params: { id: customer } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new product' do
          expect { post :create, params: { product: valid_attributes } }.to change(Product, :count)
            .by(01)
        end

        it 'returns the successfull message' do
          post :create, params: { product: valid_attributes }
          expect(flash[:notice]).to eq "Produto criado com sucesso!"
        end

        it 'redirects to the products list' do
          post :create, params: { product: valid_attributes }
          expect(response).to redirect_to(product_url(Product.last))
        end
      end

      context 'when authenticated and with produc_usages' do
        subject do
          post :create,
               params: {
                 product: {
                   name: 'Some name',
                   sku: 'SKUCode',
                   unit: 'kilograma',
                   product_usage_attributes: {
                     service_id: service.id,
                     quantity: 5
                   }
                 }
               }
        end

        it { expect(response).to be_successful }
      end

      context 'with invalid parameters' do
        before { post :create, params: { product: invalid_attributes } }

        it 'does not create a new product' do
          expect { post :create, params: { product: invalid_attributes } }.to change(
            Product,
            :count
          ).by(0)
        end

        it 'should return :unprocessable_entity 422' do
          expect(response.status).to eq 422
        end

        it "display the 'new' template" do
          expect(response).not_to be_successful
          expect(response).to render_template :new
        end
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { post :create, params: { product: valid_attributes } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'PUT /update' do
    context 'when authenticate' do
      context 'with valid parameters' do
        before { patch :update, params: { id: product, product: new_attributes } }

        it 'should assigns the customer' do
          expect(assigns(:product)).to eq product
        end

        it 'updates the requested customer' do
          expect { product.reload }.to change { product.name }.from('Some name').to('New name')
        end

        it 'redirects to the customer' do
          expect(customer.reload).to redirect_to(product_url(Product.last))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq "Produto atualizado com sucesso!"
        end
      end

      describe 'invalid attributes' do
        before { patch :update, params: { id: product, product: { name: nil } } }

        it { expect(product.name).to eq('Some name') }
        it { expect(product.name).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { patch :update, params: { id: product, product: new_attributes } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { product.save }

      it { expect { delete :destroy, params: { id: product } }.to change(Product, :count).by(-1) }

      it 'returns the flash message' do
        delete :destroy, params: { id: product }
        expect(flash[:notice]).to eq "Produto removido com sucesso!"
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { delete :destroy, params: { id: product } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
