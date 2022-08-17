class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  before_action :set_bookings, only: %i[in_progress to_completed]

  def index
    @bookings = Booking.all.order("booking_datetime DESC")
  end

  def show; end

  def new
    @booking = Booking.new(starts_at: params[:starts_at])
  end

  def edit; end

  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to booking_path(@booking), notice: "Reserva criada com sucesso!" }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_path(@booking), notice: "Reserva atualizada com sucesso!" }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_path, status: :see_other, notice: "Reserva removida com sucesso!" }
      format.json { head :no_content }
    end
  end

  def in_progress_all
    @customers = Customer
      .joins(:bookings)
      .includes(:bookings)
      .where(bookings: { status: 'in_progress' })
      .where(bookings: { starts_at: Date.today.beginning_of_day..Date.today.end_of_day } )
  end

  def in_progress
    @total_price = 0
    @total_duration = 0
    @bookings.each do |booking|
      @total_price += booking.sum_price
      @total_duration += booking.sum_duration
    end
  end

  def to_completed
    respond_to do |format|
      if @bookings.update_all status: 'completed'
        format.html { redirect_to customers_bookings_in_progress_all_path, notice: "Serviços atualizados com sucesso!" }
      else
        format.html { redirect_to customers_bookings_in_progress_all_path, status: :see_other, alert: "Não foi possível atualizar os Serviços." }
      end
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:status, :notes, :service_id, :customer_id, :professional_id, :booking_datetime, :starts_at, :ends_at)
  end

  def set_bookings
    @bookings = Booking
      .where(customer_id: params[:customer_id])
      .where(status: 'in_progress')
      .where(starts_at: Date.today.beginning_of_day..Date.today.end_of_day)
  end
end
