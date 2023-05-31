class BillsController < ApplicationController
  include Pagination

  before_action :set_bill, only: %i[show edit cancel]

  def index
    @pagination, @bills = paginate(
      Bill.all.includes(bookings: :service).order("created_at DESC"),
      page: params[:page],
      per_page: 20
    )
  end

  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bills_path, notice: "Nota em processamento, aguarde 1 minuto e atualiza a página novamente." }
      else
        puts @bill.errors.inspect
        format.html { redirect_to bills_path, alert: "Serviços já fechados. Cancele a nota fiscal gerada antes de tentar novamente." }
      end
    end
  end

  def show
  end

  def cancel
    if @bill.status == "billed"
      FocusNfeApi.new(@bill).cancel(params[:justification])
    end

    if @bill.status == "billing_canceled"
      @message = "Nota já esta cancelada."
    else
      @bill.bookings.update_all(status: :in_progress)
      @bill.update(status: :billing_canceled)
      @message = "Nota cancelada com sucesso."
    end

    respond_to do |format|
      format.html { redirect_to bills_path, status: :see_other, notice: @message }
      format.json { head :no_content }
    end
  end

  private

  def bill_params
    params.require(:bill).permit(
      { booking_ids: [], gift_card_ids: [] },
      :description,
      :discount,
      :discounted_value,
      :is_gift
    )
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end
end
