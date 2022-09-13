class BillsController < ApplicationController
  include Pagination

  URL_FOCUS_API = ENV['FOCUSNFE_URL']

  before_action :set_bookings, only: %i[create]
  before_action :set_bill, only: %i[show destroy edit update_info]

  def index
    @pagination, @bills = paginate(Bill.all.order("created_at DESC"), page: params[:page], per_page: 5)
  end

  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to customers_bookings_in_progress_all_path, notice: "Serviços atualizados com sucesso!" }
      else
        format.html { redirect_to customers_bookings_in_progress_all_path, status: :see_other, alert: "Não foi possível atualizar os Serviços." }
      end
    end
  end

  def show
  end

  def destroy
    case @bill.status
    when "billing"
      @message = "Nota ainda está em processo."
    when "billing_canceled"
      @message = "Nota já esta cancelada."
    when "billing_failed"
      @message = "Nota não foi gerada, verificar os erros."
    when "billed"
      FocusNfeApi.new(@bill).cancel(params[:justification])

      @bill.bookings.update_all(status: :billing_canceled)
      @message = "Nota cancelada com sucesso."
    end

    respond_to do |format|
      format.html { redirect_to bills_path, status: :see_other, notice: @message }
      format.json { head :no_content }
    end
  end

  private

  def bill_params
    params.require(:bill).permit({ booking_ids: [] }, :discount, :discounted_value, :is_gift)
  end

  def set_bill
    @bill = Bill.find(params[:bill_id] || params[:id])
  end

  def set_bookings
    @bookings = Booking.where(id: params[:bill][:booking_ids])
  end
end
