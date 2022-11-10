class DashboardController < ApplicationController
  before_action :set_date_start
  before_action :set_date_end

  def index
    ReportService.new(date_start: @date_start, date_end: @date_end)
  end

  private

  def set_date_start
    @date_start = params[:date_start].present? ? Date.parse(params[:date_start]) : Date.today.beginning_of_month
  end

  def set_date_end
    @date_end = params[:date_end].present? ? Date.parse(params[:date_end]) : Date.today.end_of_month
  end
end
