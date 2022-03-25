class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]

  # GET /professionals or /professionals.json
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1 or /professionals/1.json
  def show; end

  # GET /professionals/new
  def new
    @professional = current_user.build_professional
  end

  # GET /professionals/1/edit
  def edit; end

  # POST /professionals or /professionals.json
  def create
    @professional = current_user.build_professional(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: 'Professional was successfully created.' }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: 'Professional was successfully updated.' }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    @professional.destroy

    respond_to do |format|
      format.html do
        redirect_to professionals_url, notice: 'Professional was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_professional
    @professional = current_user.professional
  end

  # Only allow a list of trusted parameters through.
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