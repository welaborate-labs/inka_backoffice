class Services::HistoryController < ApplicationController
  before_action :find_service

  def show
    @bookings = @service
      .bookings
      .includes(:customer)
      .order("starts_at DESC")
      .where("starts_at >= ? AND ends_at <= ?", starts_at, ends_at)
  end

  def find_service
    @service = Service.find(params[:service_id])
  end

  def starts_at
    @starts_at ||= params[:starts_at].present? ? Date.parse(params[:starts_at]) : Date.today.beginning_of_month
  end

  def ends_at
    @ends_at ||= starts_at.end_of_month
  end
end
