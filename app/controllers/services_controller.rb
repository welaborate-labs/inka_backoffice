class ServicesController < ApplicationController
  include Autocomplete
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
          redirect_to services_path, notice: 'Serviço criado com sucesso.'
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
          redirect_to services_path, notice: 'Serviço atualizado com sucesso.'
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
      format.html { redirect_to services_url, status: :see_other, notice: 'Serviço removido com sucesso.' }
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
        :service_id,
        professional_ids: [],
        product_usages_attributes: %i[id product_id quantity _destroy]
      )
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

  def set_autocomplete_collection
    @autocomplete_collection = if params[:q]
      Service.find_by_title(params[:q])
    else
      Service.all.order("title ASC").take(5)
    end
  end
end
