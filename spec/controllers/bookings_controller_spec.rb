require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:customer) { create(:customer, :with_avatar) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:schedule_1) { create(:schedule, professional: professional) }
  let!(:service) { create(:service) }
  let(:booking) do
    create(:booking, customer: customer, service: service, professional: professional, starts_at: "2022-05-10 09:00")
  end

  let(:new_attributes) { { notes: "new notes" } }
  let(:valid_attributes) do
    {
      status: "requested",
      customer_id: customer.id,
      service_id: service.id,
      professional_id: professional.id,
      starts_at: "2022-05-10 09:00"
    }
  end
  let(:invalid_attributes) { { service_id: nil, customer_id: nil, professional_id: nil, starts_at: nil } }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user) { user } }

  describe "GET /index" do
    before { get :index }

    it { expect(response).to render_template(:index) }
    it { expect(response).to be_successful }
    it { expect(assigns(:bookings)).to include booking }
  end

  describe "GET /new" do
    context "when authenticated" do
      before { get :new }

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_successful }
      it { expect(assigns(:booking)).to be_a_new Booking }
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
        booking.save!
        get :show, params: { id: booking }
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to be_successful }
      it { expect(assigns(:booking)).to eq booking }
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        booking.save!
        get :show, params: { id: booking }
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
        booking.save!
        get :edit, params: { id: booking }
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_successful }
      it { expect(assigns(:booking)).to eq booking }
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        booking.save!
        get :edit, params: { id: booking }
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
        it "creates a new service booking" do
          expect { post :create, params: { booking: valid_attributes } }.to change(
            Booking,
            :count
          ).by(01)
        end

        it "returns the successfull message" do
          post :create, params: { booking: valid_attributes }
          expect(flash[:notice]).to eq "Reserva criada com sucesso!"
        end

        it "redirects to the calendar view" do
          post :create, params: { booking: valid_attributes }
          expect(response).to redirect_to(booking_url(Booking.last))
        end
      end

      context "with invalid parameters" do
        before { post :create, params: { booking: invalid_attributes } }
        it "does not create a new service booking" do
          expect { post :create, params: { booking: invalid_attributes } }.not_to change(
            Booking,
            :count
          )
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

      before { post :create, params: { booking: valid_attributes } }

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
          booking.save!
          patch :update, params: { id: booking, booking: new_attributes }
        end

        it "should assigns the booking" do
          expect(assigns(:booking)).to eq booking
        end

        it "updates the requested booking" do
          expect { booking.reload }.to change { booking.notes }.from("some note").to("new notes")
        end

        it "redirects to the booking" do
          expect(booking.reload).to redirect_to(booking_url(booking))
        end

        it "returns a flash message" do
          expect(flash[:notice]).to eq "Reserva atualizada com sucesso!"
        end
      end

      context "with invalid parameters" do
        before do
          booking.save!
          patch :update, params: { id: booking, booking: { status: nil } }
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
        booking.save!
        patch :update, params: { id: booking, booking: new_attributes }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end

  describe "DELETE /destroy" do
    before { booking.save! }

    describe "when authenticated" do
      it "destroys the requested booking" do
        expect { delete :destroy, params: { id: booking } }.to change(Booking, :count).by(-1)
      end

      it "returns the successfull message" do
        delete :destroy, params: { id: booking }
        expect(flash[:notice]).to eq "Reserva removida com sucesso!"
      end

      it "redirects to the calendar view" do
        delete :destroy, params: { id: booking }
        expect(response).to redirect_to(root_url)
      end
    end

    context "when does not authenticated" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user) { nil } }

      before do
        booking.save!
        delete :destroy, params: { id: booking }
      end

      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to login_url }
      it { expect(flash[:alert]).to eq "Você não esta logado(a)." }
    end
  end
end
