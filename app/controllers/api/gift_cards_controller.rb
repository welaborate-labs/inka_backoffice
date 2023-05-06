class Api::GiftCardsController < Api::BaseController
  def show
    @gift_card = GiftCard.find(params[:id])

    respond_to do |format|
      format.json { render :show, location: @gift_card }
    end
  end
end
