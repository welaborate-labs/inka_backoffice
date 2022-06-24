require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:service) { build(:service) }
  let(:main_service) { create(:service) }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  let(:new_attributes) { { title: 'New Title' } }
  let(:valid_attributes) do
    { title: 'Title', duration: 30, price: 45.50 }
  end
  let(:invalid_attributes) { { title: nil } }
  let(:optional_service) do
    {
      title: 'Title',
      duration: 30,
      price: 45.50,
      service_id: main_service.id
    }
  end

  describe 'GET /index' do
    context 'when authenticated' do
      before do
        service.save!
        get :index
      end

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:services)).to include service }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service.save!
        get :index
      end

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
      it { expect(assigns(:service)).to be_a_new Service }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :new }

      it { expect(response).not_to render_template(:new) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new service' do
          expect { post :create, params: { service: valid_attributes } }.to change(Service, :count)
            .by(01)
        end

        it 'creates a new optional service' do
          expect { post :create, params: { service: optional_service } }.to change(Service, :count)
            .by(02)
        end

        it 'returns the successfull message' do
          post :create, params: { service: valid_attributes }
          expect(flash[:notice]).to eq "Serviço criado com sucesso."
        end

        it 'redirects to the service index' do
          post :create, params: { service: valid_attributes }
          expect(response).to redirect_to(service_url(Service.last))
        end
      end

      context 'with invalid parameters' do
        before { post :create, params: { service: invalid_attributes } }
        it 'does not create a new service' do
          expect { post :create, params: { service: invalid_attributes } }.to change(
            Service,
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

      before { post :create, params: { service: valid_attributes } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before do
        service.save!
        get :show, params: { id: service }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:service)).to eq service }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service.save!
        get :show, params: { id: service }
      end

      it { expect(response).not_to render_template(:show) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before do
        service.save!
        get :edit, params: { id: service }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:service)).to eq service }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service.save!
        get :edit, params: { id: service }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'PUT /update' do
    context 'when authenticate' do
      context 'with valid parameters' do
        before do
          service.save!
          patch :update, params: { id: service, service: new_attributes }
        end

        it 'should assigns the service' do
          expect(assigns(:service)).to eq service
        end

        it 'updates the requested service' do
          expect { service.reload }.to change { service.title }
            .from('Title Service')
            .to('New Title')
        end

        it 'redirects to the service' do
          expect(service.reload).to redirect_to(service_url(service.id))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq "Serviço atualizado com sucesso."
        end
      end

      describe 'invalid attributes' do
        before do
          service.save
          patch :update, params: { id: service, service: { title: nil } }
          service.reload
        end

        it { expect(service.title).to eq('Title Service') }
        it { expect(service.title).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service.save
        patch :update, params: { id: service, service: new_attributes }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { service.save }

      it { expect { delete :destroy, params: { id: service } }.to change(Service, :count).by(-1) }

      it 'returns the flash message' do
        delete :destroy, params: { id: service }
        expect(flash[:notice]).to eq "Serviço removido com sucesso."
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service.save
        delete :destroy, params: { id: service }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
