module BookingsHelper
  def status_attributes_for_select
    Booking.statuses.map do |status, _|
      [I18n.t("activerecord.attributes.booking.statuses.#{status}"), status]
    end
  end
end
