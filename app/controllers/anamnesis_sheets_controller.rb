class AnamnesisSheetsController < ApplicationController
  before_action :set_anamnesis_sheet, only: %i[show edit update destroy]
  before_action :set_jwt_token, only: %i[new]
  before_action :verify_token, only: %i[new create]

  def index
    @anamnesis_sheets = current_user.customer.anamnesis_sheets
  end

  def show
  end

  def new
    @anamnesis_sheet = current_user.customer.anamnesis_sheets.build
  end

  def edit
  end

  def create
    @anamnesis_sheet = current_user.customer.anamnesis_sheets.build(anamnesis_sheet_params)

    respond_to do |format|
      if @anamnesis_sheet.save
        format.html { redirect_to anamnesis_sheet_url(@anamnesis_sheet), notice: "Anamnesis sheet was successfully created." }
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
        format.html { redirect_to anamnesis_sheet_url(@anamnesis_sheet), notice: "Anamnesis sheet was successfully updated." }
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
      format.html { redirect_to anamnesis_sheets_url, notice: "Anamnesis sheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def qrcode_link_generate
    @token = JsonWebToken.encode
    qrcode = Qrcode.create_anemnesis_sheet(@token)

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

  def anamnesis_sheet_params
    params.require(:anamnesis_sheet).permit(:title, :customer_id)
  end

  def set_jwt_token
    @token ||= params[:token]
  end

  def verify_token
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
      redirect_to anamnesis_sheets_path, alert: "Token não encontrado."
    end
  end
end
