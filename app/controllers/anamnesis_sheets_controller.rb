class AnamnesisSheetsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_customer
  before_action :set_anamnesis_sheet, only: %i[show edit update destroy]
  before_action :set_jwt_token, only: %i[new]
  before_action :verify_token_or_authenticated, only: %i[new create]
  before_action :set_new_path_qr_code, only: %i[new]

  def index
    @anamnesis_sheets = AnamnesisSheet.all
  end

  def show
  end

  def new
    if params[:token]
      @anamnesis_sheet = @customer.anamnesis_sheets.build
    end
  end

  def edit
  end

  def create
    @anamnesis_sheet = @customer.anamnesis_sheets.build(anamnesis_sheet_params)

    respond_to do |format|
      if @anamnesis_sheet.save
        format.html { redirect_to anamnesis_sheet_url(@anamnesis_sheet), notice: "Ficha de Anamnese criada com sucesso" }
        format.json { render :show, status: :created, location: @anamnesis_sheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anamnesis_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @anamnesis_sheet.update(anamnesis_sheet_params)
        format.html { redirect_to anamnesis_sheet_url(@anamnesis_sheet), notice: "Ficha de Anamnese alterada com sucesso" }
        format.json { render :show, status: :ok, location: @anamnesis_sheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anamnesis_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @anamnesis_sheet.destroy

    respond_to do |format|
      format.html { redirect_to anamnesis_sheets_url, notice: "Ficha de Anamnese removida." }
      format.json { head :no_content }
    end
  end

  def qrcode_link_generate
    @token = JsonWebToken.encode
    qrcode = Qrcode.create_anemnesis_sheet(link)

    respond_to do |format|
      if @token && qrcode
        format.html { redirect_to anamnesis_sheets_path, notice: "Link e Qrcode criados com sucesso." }
        format.json { render :index, token: @token, status: :ok }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render error: "algo deu errado.", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_anamnesis_sheet
    @anamnesis_sheet = AnamnesisSheet.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def customer_sheet_params
    params.require(:customer).permit(:address, :birth_date, :document, :email, :gender, :phone)
  end

  def anamnesis_sheet_params
    params.require(:anamnesis_sheet).permit(
      :address,
      :birth_date,
      :document,
      :email,
      :gender,
      :phone,
      :recent_cirurgy,
      :recent_cirurgy_details,
      :cronic_diseases,
      :cronic_diseases_details,
      :pregnant,
      :lactating,
      :medicine_usage,
      :skin_type,
      :skin_acne,
      :skin_scars,
      :skin_spots,
      :skin_normal,
      :psoriasis,
      :dandruff,
      :skin_peeling,
      :cosmetic_allergies,
      :cosmetic_allergies_details,
      :food_allergies,
      :food_allergies_details,
      :has_period,
      :period_details,
      :had_therapy_before,
      :made_therapy_details,
      :current_main_concern,
      :change_motivations,
      :emotion,
      :confidentiality_aggreement,
      :image_usage_aggreement,
      :responsibility_aggreement,
    )
  end

  def set_jwt_token
    @token ||= params[:token]
  end

  def verify_token_or_authenticated
    if params[:token]
      respond_to do |format|
        if JsonWebToken.decode(params[:token])
          return
        else
          format.html { redirect_to anamnesis_sheets_path, alert: "Token inválido ou expirado." }
          format.json { render json: { error: "Token inválido ou expirado." }, status: :unprocessable_entity }
        end
      end
    else
      authenticate_user!
    end
  end

  def set_new_path_qr_code
    unless params[:token]
      @token = JsonWebToken.encode
      @qrcode = RQRCode::QRCode.new(new_customer_anamnesis_sheet_url(@customer, token: @token))
    end
  end
end
