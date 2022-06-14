class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]
  before_action :check_existing_professional, only: %i[new create]

  def index
    @professionals = Professional.all
  end

  def show; end

  def new
    @professional = current_user.build_professional
  end

  def edit; end

  def create
    @professional = current_user.build_professional(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: 'Profissional criado com sucesso!' }
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
        format.html { redirect_to @professional, notice: 'Profissional atualizado com sucesso!' }
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
      format.html do
        redirect_to professionals_url, notice: 'Profissional removido com sucesso!'
      end
      format.json { head :no_content }
    end
  end

  private

  def check_existing_professional
    if current_user.professional
      return redirect_to professionals_url, alert: 'Esta conta já possui um profissional cadastrado.'
    end
  end

  def set_professional
    professional = Professional.find(params[:id])
    @professional = current_user.professional
    if professional != @professional
      return redirect_to professionals_url, alert: 'Profissional não encontrado para o usuário atual!'
    end
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
