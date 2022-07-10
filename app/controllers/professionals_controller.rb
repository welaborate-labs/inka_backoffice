class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]

  def index
    @professionals = Professional.all
  end

  def show; end

  def new
    @professional = Professional.new
  end

  def edit; end

  def create
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to professionals_path, notice: 'Profissional criado com sucesso!' }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to professionals_path, notice: 'Profissional atualizado com sucesso!' }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @professional.destroy

    respond_to do |format|
      format.html { redirect_to professionals_url, status: :see_other, notice: 'Profissional removido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private

  def set_professional
    @professional = Professional.find(params[:id])
  end

  def professional_params
    params
      .require(:professional)
      .permit(
        :name,
        :email,
        :phone,
        :address,
        :document,
        :avatar,
        :user_id,
        service_ids: [],
        schedules_attributes: %i[
          weekday
          starts_at
          ends_at
          interval_starts_at
          interval_ends_at
          id
          _destroy
        ]
      )
  end
end
