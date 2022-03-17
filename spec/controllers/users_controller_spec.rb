require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:new_attributes) { { name: 'Jane Doe' } }
  let(:valid_attributes) { { uid: identity.id, email: 'john.doe@example.com', name: 'John Doe', phone: '1199998888' } }
  let(:invalid_attributes) { { uid: nil, email: nil, name: nil, phone: nil } }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe 'GET /index' do
    before do
      user.save!
      get :index
    end

    it { expect(response).to render_template(:index) }
    it { expect(response).to be_successful }
    it { expect(assigns(:users)).to include user }
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before do
        user.save!
        get :edit, params: { id: user }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:user)).to eq user }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        user.save!
        get :edit, params: { id: user }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'PATCH /update' do
    context 'when authenticated' do
      context 'with valid parameters' do
        before do
          user.save!
          patch :update, params: { id: user, user: new_attributes }
        end

        it 'should assigns the user' do
          expect(assigns(:user)).to eq user
        end

        it 'updates the requested user' do
          expect { user.reload }.to change { user.name }.from('John Doe').to('Jane Doe')
        end

        it 'redirects to the user' do
          expect(user.reload).to redirect_to(root_url)
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq 'User was successfully updated.'
        end
      end

      context 'with invalid parameters' do
        before do
          user.save!
          patch :update, params: { id: user, user: { name: nil } }
        end

        it 'should return :unprocessable_entity 422' do
          expect(response.status).to eq 422
        end

        it "display the 'edit' template" do
          expect(response).not_to be_successful
          expect(response).to render_template :edit
        end
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        user.save!
        patch :update, params: { id: user, user: new_attributes }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'DELETE /destroy' do
    before { user.save! }

    describe 'when authenticated' do
      it 'destroys the requested user' do
        expect { delete :destroy, params: { id: user } }.to change(User, :count).by(-1)
      end

      it 'returns the successfull message' do
        delete :destroy, params: { id: user }
        expect(flash[:notice]).to eq 'User was successfully destroyed.'
      end

      it 'redirects to the courses list' do
        delete :destroy, params: { id: user }
        expect(response).to redirect_to(users_url)
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        user.save!
        delete :destroy, params: { id: user }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end
end
