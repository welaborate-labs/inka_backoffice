class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  before_action :set_customers, only: %i[new create edit update]
  before_action :set_services, only: %i[new create edit update]
  before_action :set_professional, only: %i[create edit update]

  def index
    @bookings = Booking.all.order("updated_at DESC")
  end

  def show
  end

  def new
    @booking ||= Booking.new
    @booking.booking_datetime = params[:booking_date]&.to_datetime
  end

  def edit
  end

  def create
    @booking ||= Booking.new(booking_params)
    @booking.professional_id = @professional.id

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
        format.html do
          redirect_to booking_path(@booking), notice: "Reserva atualizada com sucesso!"
        end
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
      format.html { redirect_to root_url, notice: "Reserva removida com sucesso!" }
      format.json { head :no_content }
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :status,
      :notes,
      :service_id,
      :customer_id,
      :canceled_at,
      :booking_datetime
    )
  end

  def set_customers
    @customers ||= Customer.all.select(:id, :name)
  end

  def set_services
    @services ||= Service.all.select(:id, :title)
  end

  def set_professional
    service = Service.find(booking_params[:service_id])
    @professional = Professional.find(service.professional_id)
  end
end
