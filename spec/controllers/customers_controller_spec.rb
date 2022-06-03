require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:customer) { build(:customer, :with_avatar) }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  let(:avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'model.png')) }

  let(:new_attributes) { { name: 'Jane Doe' } }
  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '1199998888',
      address: 'Some Random Address',
      document: '12345678909',
      avatar: avatar
    }
  end
  let(:invalid_attributes) { { name: nil } }

  describe 'GET /index' do
    context 'when authenticated' do
      before do
        customer.save!
        get :index
      end

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:customers)).to include customer }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        customer.save!
        get :index
      end

      it { expect(response).not_to render_template(:index) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:customer)).to be_a_new Customer }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :new }

      it { expect(response).not_to render_template(:new) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before do
        customer.save!
        get :show, params: { id: customer }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:customer)).to eq customer }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        customer.save!
        get :show, params: { id: customer }
      end

      it { expect(response).not_to render_template(:show) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before do
        customer.save!
        get :edit, params: { id: customer }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:customer)).to eq customer }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        customer.save!
        get :edit, params: { id: customer }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new customer' do
          expect { post :create, params: { customer: valid_attributes } }.to change(
            Customer,
            :count
          ).by(01)
        end

        it 'returns the successfull message' do
          post :create, params: { customer: valid_attributes }
          expect(flash[:notice]).to eq 'Customer was successfully created.'
        end

        it 'redirects to the customers list' do
          post :create, params: { customer: valid_attributes }
          expect(response).to redirect_to(customer_url(Customer.last))
        end
      end

      context 'with invalid parameters' do
        before { post :create, params: { customer: invalid_attributes } }
        it 'does not create a new customer' do
          expect { post :create, params: { customer: invalid_attributes } }.to change(
            Customer,
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

      before { post :create, params: { customer: valid_attributes } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'PUT /update' do
    context 'when authenticate' do
      context 'with valid parameters' do
        before do
          customer.save!
          patch :update, params: { id: customer, customer: new_attributes }
        end

        it 'should assigns the customer' do
          expect(assigns(:customer)).to eq customer
        end

        it 'updates the requested customer' do
          expect { customer.reload }.to change { customer.name }.from('John Doe').to('Jane Doe')
        end

        it 'redirects to the customer' do
          expect(customer.reload).to redirect_to(customer_url(customer))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq 'Customer was successfully updated.'
        end
      end

      describe 'invalid attributes' do
        before do
          customer.save
          patch :update, params: { id: customer, customer: { name: nil } }
          customer.reload
        end

        it { expect(customer.name).to eq('John Doe') }
        it { expect(customer.name).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        customer.save
        patch :update, params: { id: customer, customer: new_attributes }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { customer.save }

      it do
        expect { delete :destroy, params: { id: customer } }.to change(Customer, :count).by(-1)
      end

      it 'returns the flash message' do
        delete :destroy, params: { id: customer }
        expect(flash[:notice]).to eq 'Customer was successfully destroyed.'
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        customer.save
        delete :destroy, params: { id: customer.to_param }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end
end
