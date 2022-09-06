class GiftCardTemplatesController < ApplicationController
  before_action :set_gift_card_template, only: %i[ show edit update destroy ]

  # GET /gift_card_templates or /gift_card_templates.json
  def index
    @gift_card_templates = GiftCardTemplate.all
  end

  # GET /gift_card_templates/1 or /gift_card_templates/1.json
  def show
  end

  # GET /gift_card_templates/new
  def new
    @gift_card_template = GiftCardTemplate.new
  end

  # GET /gift_card_templates/1/edit
  def edit
  end

  # POST /gift_card_templates or /gift_card_templates.json
  def create
    @gift_card_template = GiftCardTemplate.new(gift_card_template_params)

    respond_to do |format|
      if @gift_card_template.save
        format.html { redirect_to gift_card_template_url(@gift_card_template), notice: "Modelo de Vale Presente criado com sucesso." }
        format.json { render :show, status: :created, location: @gift_card_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gift_card_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gift_card_templates/1 or /gift_card_templates/1.json
  def update
    respond_to do |format|
      if @gift_card_template.update(gift_card_template_params)
        format.html { redirect_to gift_card_template_url(@gift_card_template), notice: "Modelo de Vale Presente atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @gift_card_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gift_card_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gift_card_templates/1 or /gift_card_templates/1.json
  def destroy
    @gift_card_template.destroy

    respond_to do |format|
      format.html { redirect_to gift_card_templates_url, notice: "Modelo de Vale Presente removido com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gift_card_template
      @gift_card_template = GiftCardTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gift_card_template_params
      params.require(:gift_card_template).permit(:price, :name, { service_ids: [] }, { gift_card_ids: [] })
    end
end
