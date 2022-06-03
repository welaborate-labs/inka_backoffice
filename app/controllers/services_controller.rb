class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy]
  before_action :set_services, only: %i[new create edit update]
  before_action :set_products, only: %i[new create edit update]
  before_action :set_professional, only: %i[new create edit update]

  def index
    @services = Service.all
  end

  def show; end

  def new
    @service = Service.new
  end

  def edit; end

  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html do
          redirect_to service_url(@service), notice: 'Service was successfully created.'
        end
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html do
          redirect_to service_url(@service), notice: 'Service was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params
      .require(:service)
      .permit(
        :title,
        :duration,
        :price,
        :is_comissioned,
        :professional_id,
        :service_id,
        product_usages_attributes: %i[product_id quantity _destroy]
      )
      .merge(professional: @professional)
  end

  def set_professional
    @professional ||= Professional.find_by(user_id: current_user.id)
  end

  def set_services
    @services ||= Service.all
  end

  def set_products
    @products ||= Product.all
  end
end
