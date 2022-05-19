require 'rails_helper'

RSpec.describe ProfessionalsController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:customer) { build(:customer, :with_avatar) }

  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'model.png')) }
  let(:new_attributes) { { address: 'Some New Address For Testing' } }
  let(:invalid_attributes) { { name: nil } }
  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'john.doe2@example.com',
      phone: '1199997777',
      address: 'Some Random Address',
      document: '12345678908',
      avatar: avatar
    }
  end

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe 'GET /index' do
    context 'when authenticated' do
      before { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:professionals)).to include professional }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :index }

      it { expect(response).not_to render_template(:index) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:professional)).to be_a_new Professional }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :new }

      it { expect(response).not_to render_template(:new) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before { get :show, params: { id: professional } }

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:professional)).to eq professional }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :show, params: { id: professional } }

      it { expect(response).not_to render_template(:show) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before { get :edit, params: { id: professional } }

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:professional)).to eq professional }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :edit, params: { id: professional } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new professional' do
          expect { post :create, params: { professional: valid_attributes } }.to change(
            Professional,
            :count
          ).by(01)
        end

        it 'should accept nested fields for schedules' do
          params = {
            professional: {
              schedules_attributes: [
                {
                  weekday: 2,
                  starts_at: '07:00',
                  ends_at: '19:00',
                  interval_starts_at: '12:00',
                  interval_ends_at: '13:00'
                }
              ]
            }
          }

          expect { professional.update! params[:professional] }.to change(Schedule, :count).by(01)
        end

        it 'returns the successfull message' do
          post :create, params: { professional: valid_attributes }
          expect(flash[:notice]).to eq 'Professional was successfully created.'
        end

        it 'redirects to the #show professional' do
          post :create, params: { professional: valid_attributes }
          expect(response).to redirect_to(professional_url(Professional.last))
        end
      end

      context 'with invalid parameters' do
        before { post :create, params: { professional: invalid_attributes } }
        it 'does not create a new professional' do
          expect { post :create, params: { professional: invalid_attributes } }.to change(
            Professional,
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

      before { post :create, params: { professional: valid_attributes } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'PUT /update' do
    context 'when authenticate' do
      context 'with valid parameters' do
        before { patch :update, params: { id: professional, professional: new_attributes } }

        it 'should assigns the professional' do
          expect(assigns(:professional)).to eq professional
        end

        it 'updates the requested professional' do
          expect(professional.address).to eq 'Some New Address For Testing'
        end

        it 'redirects to the professional' do
          expect(professional.reload).to redirect_to(professional_url(professional))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq 'Professional was successfully updated.'
        end
      end

      describe 'invalid attributes' do
        before do
          patch :update, params: { id: professional, professional: { name: nil } }
          professional.reload
        end

        it { expect(professional.name).to eq('John Doe') }
        it { expect(professional.name).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        professional.save
        patch :update, params: { id: professional, professional: new_attributes }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { professional.save }

      it do
        expect { delete :destroy, params: { id: professional } }.to change(Professional, :count)
          .by(-1)
      end

      it 'returns the flash message' do
        delete :destroy, params: { id: professional }
        expect(flash[:notice]).to eq 'Professional was successfully destroyed.'
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { delete :destroy, params: { id: professional } }

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end
end
