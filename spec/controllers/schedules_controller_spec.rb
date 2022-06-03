require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { build(:professional, :with_avatar, user: user) }
  let(:schedule) { build(:schedule, professional: professional) }
  let(:new_attributes) { { weekday: 'tuesday' } }
  let(:valid_attributes) do
    {
      weekday: 'monday',
      starts_at: '07:00',
      ends_at: '18:00',
      interval_starts_at: '12:00',
      interval_ends_at: '13:00',
      professional_id: professional.id
    }
  end
  let(:invalid_attributes) { { weekday: nil } }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe 'GET /index' do
    context 'when authenticated' do
      before do
        schedule.save!
        get :index
      end

      it { expect(response).to render_template(:index) }
      it { expect(response).to be_successful }
      it { expect(assigns(:schedules)).to include schedule }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        schedule.save!
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
      it { expect(assigns(:schedule)).to be_a_new Schedule }
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
        schedule.save!
        get :show, params: { id: schedule }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:schedule)).to eq schedule }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        schedule.save!
        get :show, params: { id: schedule }
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
        schedule.save!
        get :edit, params: { id: schedule }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:schedule)).to eq schedule }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        schedule.save!
        get :edit, params: { id: schedule }
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
        it 'creates a new schedule' do
          expect { post :create, params: { schedule: valid_attributes } }.to change(
            Schedule,
            :count
          ).by(01)
        end

        it 'returns the successfull message' do
          post :create, params: { schedule: valid_attributes }
          expect(flash[:notice]).to eq 'Schedule was successfully created.'
        end

        it 'redirects to the #show schedule' do
          post :create, params: { schedule: valid_attributes }
          expect(response).to redirect_to(schedule_url(Schedule.last))
        end
      end

      context 'with invalid parameters' do
        before { post :create, params: { schedule: invalid_attributes } }
        it 'does not create a new schedule' do
          expect { post :create, params: { schedule: invalid_attributes } }.to change(
            Schedule,
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

      before { post :create, params: { schedule: valid_attributes } }

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
          schedule.save!
          patch :update, params: { id: schedule, schedule: new_attributes }
        end

        it 'should assigns the schedule' do
          expect(assigns(:schedule)).to eq schedule
        end

        it 'updates the requested schedule' do
          expect { schedule.reload }.to change { schedule.weekday }.from('monday').to('tuesday')
        end

        it 'redirects to the schedule' do
          expect(schedule.reload).to redirect_to(schedule_url(schedule))
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq 'Schedule was successfully updated.'
        end
      end

      describe 'invalid attributes' do
        before do
          schedule.save
          patch :update, params: { id: schedule, schedule: { weekday: nil } }
          schedule.reload
        end

        it { expect(schedule.weekday).to eq('monday') }
        it { expect(schedule.weekday).not_to eq(nil) }
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        schedule.save
        patch :update, params: { id: schedule, schedule: new_attributes }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'DELETE /destroy' do
    context 'when authenticated' do
      before { schedule.save }

      it do
        expect { delete :destroy, params: { id: schedule } }.to change(Schedule, :count).by(-1)
      end

      it 'returns the flash message' do
        delete :destroy, params: { id: schedule }
        expect(flash[:notice]).to eq 'Schedule was successfully destroyed.'
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        schedule.save
        delete :destroy, params: { id: schedule }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_path }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end
end
