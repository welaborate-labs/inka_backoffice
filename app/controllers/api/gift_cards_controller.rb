class Api::GiftCardsController < Api::BaseController
  def show
    @gift_card = GiftCard.find(params[:id])

    render json: @gift_card.to_json(except: [:bill_id, :booking_id, :price])
  end
end
