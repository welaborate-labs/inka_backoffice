class BillsController < ApplicationController
  before_action :set_bookings, only: %i[create]
  before_action :set_bill, only: %i[destroy edit]

  def index
    @bills = Bill.all.order("created_at DESC")
  end

  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save && @bookings.update_all(status: "completed")
        format.html { redirect_to customers_bookings_in_progress_all_path, notice: "Serviços atualizados com sucesso!" }
      else
        format.html { redirect_to customers_bookings_in_progress_all_path, status: :see_other, alert: "Não foi possível atualizar os Serviços." }
      end
    end
  end

  def destroy
    FocusNfeApi.new(@bill).cancel(params[:justification])

    respond_to do |format|
      format.html { redirect_to bills_path, status: :see_other, notice: "Nota Fiscal removida com sucesso!" }
      format.json { head :no_content }
    end
  end

  private

  def bill_params
    params.require(:bill).permit({ booking_ids: []}, :discount, :is_gift)
  end

  def set_bill
    @bill = Bill.find(params[:bill_id] || params[:id])
  end

  def set_bookings
    @bookings = Booking.where(id: params[:bill][:booking_ids])
  end
end
