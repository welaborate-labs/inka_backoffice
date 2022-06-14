require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  let(:user) { create(:user) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:service) { create(:service, professional: professional) }
  let(:product) { create(:product) }

  let(:stock_increment) { create(:stock, type: 'StockIncrement', product: product) }
  let(:stock_decrement) { create(:stock, type: 'StockDecrement', product: product) }
  let!(:stock) { StockIncrement.find stock_increment.id }

  let(:new_attributes) { { quantity: 5 } }
  let(:valid_attributes) do
    { product_id: product.id, quantity: 1, type: 'StockDecrement', integralized_at: DateTime.now }
  end
  let(:invalid_attributes) { { quantity: nil, type: 'StockIncrement' } }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe 'GET /index' do
    context 'when authenticated' do
      before { get :index, params: { product_id: product.id, type: 'Stock' } }

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:stocks)).to include stock_increment, stock_decrement }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :index, params: { product_id: product.id, type: 'Stock' } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before { get :new, params: { product_id: product.id, type: 'Stock' } }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:stock)).to be_a_new Stock }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before { get :new, params: { product_id: product.id, type: 'Stock' } }

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before do
        get :show,
            params: {
              product_id: product.id,
              type: 'StockIncrement',
              id: stock_increment.id
            }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:stock)).to eq stock }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before do
        get :show,
            params: {
              product_id: product.id,
              type: 'StockIncrement',
              id: stock_increment.id
            }
      end

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before do
        get :edit,
            params: {
              product_id: product.id,
              type: 'StockIncrement',
              id: stock_increment.id
            }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:stock)).to eq stock }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }
      before do
        get :show,
            params: {
              product_id: product.id,
              type: 'StockIncrement',
              id: stock_increment.id
            }
      end

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new product' do
          expect {
            post :create,
                 params: {
                   stock: valid_attributes,
                   product_id: product.id,
                   type: 'StockIncrement'
                 }
          }.to change(Stock, :count).by(01)
        end

        it 'returns the successfull message' do
          post :create,
               params: {
                 stock: valid_attributes,
                 product_id: product.id,
                 type: 'StockIncrement'
               }
          expect(flash[:notice]).to eq "Estoque criado com sucesso."
        end

        it 'redirects to the stocks list' do
          post :create,
               params: {
                 stock: valid_attributes,
                 product_id: product.id,
                 type: 'StockIncrement'
               }
          expect(response).to redirect_to(product_stock_url(product.id, Stock.last))
        end
      end

      context 'with invalid parameters' do
        before do
          post :create,
               params: {
                 stock: invalid_attributes,
                 product_id: product.id,
                 type: 'StockIncrement'
               }
        end

        it 'does not create a new product' do
          expect {
            post :create,
                 params: {
                   stock: invalid_attributes,
                   product_id: product.id,
                   type: 'StockIncrement'
                 }
          }.to change(Stock, :count).by(0)
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
      before do
        post :create,
             params: {
               stock: valid_attributes,
               product_id: product.id,
               type: 'StockIncrement'
             }
      end

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'PUT /update' do
    context 'when authenticate' do
      context 'with valid parameters' do
        before do
          patch :update,
                params: {
                  stock: new_attributes,
                  product_id: product.id,
                  type: 'StockIncrement',
                  id: stock.id
                }
        end

        it 'should assigns the stock' do
          expect(assigns(:stock)).to eq stock
        end

        it 'updates the requested stock' do
          expect { stock.reload }.to change { stock.quantity }.from(1).to(5)
        end

        it 'redirects to the stock' do
          expect(stock.reload).to redirect_to(product_stocks_url(product.id))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq "Estoque atualizado com sucesso."
        end
      end

      describe 'invalid attributes' do
        before do
          patch :update,
                params: {
                  stock: {
                    quantity: nil
                  },
                  product_id: product.id,
                  type: 'StockIncrement',
                  id: stock.id
                }
        end

        it { expect(stock.quantity).to eq(1) }
        it { expect(stock.quantity).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        patch :update,
              params: {
                stock: new_attributes,
                product_id: product.id,
                type: 'StockIncrement',
                id: stock.id
              }
      end

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      it do
        expect {
          delete :destroy,
                 params: {
                   product_id: product.id,
                   type: 'StockIncrement',
                   id: stock_increment.id
                 }
        }.to change(Stock, :count).by(-1)
      end

      it 'returns the flash message' do
        delete :destroy,
               params: {
                 product_id: product.id,
                 type: 'StockIncrement',
                 id: stock_increment.id
               }
        expect(flash[:notice]).to eq "Estoque removido com sucesso."
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        delete :destroy,
               params: {
                 product_id: product.id,
                 type: 'StockIncrement',
                 id: stock_increment.id
               }
      end

      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
