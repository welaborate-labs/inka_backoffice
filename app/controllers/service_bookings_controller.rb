class ServiceBookingsController < ApplicationController
  before_action :set_service_booking, only: %i[show edit update destroy]

  def index
    @service_bookings = ServiceBooking.all.order('updated_at DESC')
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
        format.html { redirect_to root_url, notice: 'Service booking was successfully created.' }
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
        format.html { redirect_to root_path, notice: 'Service booking was successfully updated.' }
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
      format.html { redirect_to root_url, notice: 'Service booking was successfully destroyed.' }
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
      .permit(:status, :notes, :canceledAt, :customer_id, :timeslot_id)
  end
end
