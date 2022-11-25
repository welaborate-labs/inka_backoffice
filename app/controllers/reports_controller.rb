class ReportsController < ApplicationController
  layout 'reports'

  before_action :set_dates

  def index
    @report = ReportService.new(date_start: @starts_at, date_end: @ends_at)
  end

  private

  def set_dates
    @starts_at = params[:starts_at] ? Date.new(params[:starts_at]) : Date.today.beginning_of_month
    @ends_at = params[:ends_at]  ? Date.new(params[:ends_at]) : Date.today.end_of_month
  end
end
