require 'rails_helper'

RSpec.describe ServiceBookingsController, type: :controller do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { create(:professional, :with_avatar, user_id: user.id) }
  let(:schedule) { create(:schedule, professional_id: professional.id) }
  let(:timeslot) { create(:timeslot, schedule_id: schedule.id) }
  let(:customer) { create(:customer, :with_avatar) }
  let(:service_booking) do
    build(:service_booking, customer_id: customer.id, timeslot_id: timeslot.id)
  end

  let(:new_attributes) { { status: 'requested' } }
  let(:valid_attributes) do
    { notes: 'note', status: 'accepted', customer_id: customer.id, timeslot_id: timeslot.id }
  end
  let(:invalid_attributes) { { status: nil, customer_id: nil, timeslot_id: nil } }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe 'GET /index' do
    before do
      service_booking.save!
      get :index
    end

    it { expect(response).to render_template(:index) }
    it { expect(response).to be_successful }
    it { expect(assigns(:service_bookings)).to include service_booking }
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:service_booking)).to be_a_new ServiceBooking }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before { get :new }

      it { expect(response).not_to render_template(:new) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /show' do
    context 'when authenticated' do
      before do
        service_booking.save!
        get :show, params: { id: service_booking }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:service_booking)).to eq service_booking }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service_booking.save!
        get :show, params: { id: service_booking }
      end

      it { expect(response).not_to render_template(:show) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'GET /edit' do
    context 'when authenticated' do
      before do
        service_booking.save!
        get :edit, params: { id: service_booking }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:service_booking)).to eq service_booking }
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service_booking.save!
        get :edit, params: { id: service_booking }
      end

      it { expect(response).not_to render_template(:edit) }
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      context 'with valid parameters' do
        it 'creates a new service booking' do
          expect { post :create, params: { service_booking: valid_attributes } }.to change(
            ServiceBooking,
            :count
          ).by(01)
        end

        it 'returns the successfull message' do
          post :create, params: { service_booking: valid_attributes }
          expect(flash[:notice]).to eq 'Service booking was successfully created.'
        end

        it 'redirects to the calendar view' do
          post :create, params: { service_booking: valid_attributes }
          expect(response).to redirect_to(root_url)
        end
      end

      context 'with invalid parameters' do
        before { post :create, params: { service_booking: invalid_attributes } }
        it 'does not create a new schedule' do
          expect { post :create, params: { service_booking: invalid_attributes } }.to change(
            ServiceBooking,
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

      before { post :create, params: { service_booking: valid_attributes } }

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
          service_booking.save!
          patch :update, params: { id: service_booking, service_booking: new_attributes }
        end

        it 'should assigns the service_booking' do
          expect(assigns(:service_booking)).to eq service_booking
        end

        it 'updates the requested service_booking' do
          expect { service_booking.reload }.to change { service_booking.status }
            .from('accepted')
            .to('requested')
        end

        it 'redirects to the service_booking' do
          expect(service_booking.reload).to redirect_to(root_url)
        end

        it 'returns a flash message' do
          expect(flash[:notice]).to eq 'Service booking was successfully updated.'
        end
      end

      context 'with invalid parameters' do
        before do
          service_booking.save!
          patch :update, params: { id: service_booking, service_booking: { status: nil } }
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
    before { service_booking.save! }

    describe 'when authenticated' do
      it 'destroys the requested service_booking' do
        expect { delete :destroy, params: { id: service_booking } }.to change(
          ServiceBooking,
          :count
        ).by(-1)
      end

      it 'returns the successfull message' do
        delete :destroy, params: { id: service_booking }
        expect(flash[:notice]).to eq 'Service booking was successfully destroyed.'
      end

      it 'redirects to the calendar view' do
        delete :destroy, params: { id: service_booking }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when does not authenticated' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        service_booking.save!
        delete :destroy, params: { id: service_booking }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:alert]).to eq 'You are not logged in.' }
    end
  end
end