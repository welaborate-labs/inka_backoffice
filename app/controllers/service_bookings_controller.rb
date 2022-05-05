class ServiceBookingsController < ApplicationController
  before_action :set_service_booking, only: %i[show edit update destroy]

  def index
    @service_bookings = ServiceBooking.all
  end

  def show; end

  def new
    @service_booking = ServiceBooking.new
  end

  def edit; end

  def create
    @service_booking = ServiceBooking.new(service_booking_params)

    respond_to do |format|
      if @service_booking.save
        format.html do
          redirect_to service_booking_url(@service_booking),
                      notice: 'Service booking was successfully created.'
        end
        format.json { render :show, status: :created, location: @service_booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service_booking.update(service_booking_params)
        format.html do
          redirect_to service_booking_url(@service_booking),
                      notice: 'Service booking was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @service_booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service_booking.destroy

    respond_to do |format|
      format.html do
        redirect_to service_bookings_url, notice: 'Service booking was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def set_service_booking
    @service_booking = ServiceBooking.find(params[:id])
  end

  def service_booking_params
    params
      .require(:service_booking)
      .permit(:status, :presence, :notes, :canceledAt, :customer_id, :timeslot_id)
  end
end
