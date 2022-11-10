require "rails_helper"
require "services/focus_nfe_api"

RSpec.describe ReportService do
  let(:user) { create(:user) }
  let(:professional_1) { create(:professional, user_id: user.id) }
  let!(:schedule_1) { create(:schedule, professional_id: professional_1.id, weekday: 1) }
  let!(:schedule_2) { create(:schedule, professional_id: professional_1.id, weekday: 2) }

  let(:service_1) { create(:service, title: "Random service 1") }
  let(:service_2) { create(:service, title: "Random service 2") }
  let(:service_3) { create(:service, title: "Random service 3") }
  let(:service_4) { create(:service, title: "Random service 4") }
  let(:service_5) { create(:service, title: "Random service 5") }

  let(:customer_1) { create(:customer, :with_avatar, user_id: user.id, created_at: DateTime.new(2022, 11, 3, 9)) }
  let(:customer_2) { create(:customer, :with_avatar, user_id: user.id, created_at: DateTime.new(2022, 11, 27, 9)) }
  let(:customer_3) { create(:customer, :with_avatar, user_id: user.id, created_at: DateTime.new(2022, 10, 3, 9)) }
  let(:customer_4) { create(:customer, :with_avatar, user_id: user.id, created_at: DateTime.new(2022, 5, 5, 9)) }

  let(:booking_1) { create(:booking, service: service_1, customer: customer_1, professional: professional_1, starts_at: DateTime.new(2022, 11, 7, 9)) }
  let(:booking_2) { create(:booking, service: service_2, customer: customer_1, professional: professional_1, starts_at: DateTime.new(2022, 11, 7, 10)) }

  let(:booking_3) { create(:booking, service: service_3, customer: customer_2, professional: professional_1, starts_at: DateTime.new(2022, 11, 7, 8)) }
  let(:booking_4) { create(:booking, service: service_1, customer: customer_2, professional: professional_1, starts_at: DateTime.new(2022, 10, 3, 9), created_at: DateTime.new(2022, 10, 3, 9)) }

  let(:booking_5) { create(:booking, service: service_5, customer: customer_3, professional: professional_1, starts_at: DateTime.new(2022, 10, 3, 14), created_at: DateTime.new(2022, 10, 3, 9)) }

  let(:booking_6) { create(:booking, service: service_1, customer: customer_4, professional: professional_1, starts_at: DateTime.new(2022, 11, 14, 14)) }

  let(:booking_7) { create(:booking, service: service_2, customer: customer_1, professional: professional_1, starts_at: DateTime.new(2022, 11, 15, 9)) }
  let(:booking_8) { create(:booking, service: service_3, customer: customer_1, professional: professional_1, starts_at: DateTime.new(2022, 11, 15, 14)) }

  let(:bill_1) { create(:bill, bookings: [booking_1, booking_2]) }
  let(:bill_2) { create(:bill, bookings: [booking_3, booking_4]) }
  let(:bill_3) { create(:bill, bookings: [booking_5]) }
  let(:bill_4) { create(:bill, bookings: [booking_6]) }
  let(:bill_5) { create(:bill, bookings: [booking_7, booking_8]) }

  let(:report_service) { ReportService.new(date_start: DateTime.new(2022, 11, 1, 6), date_end: DateTime.new(2022, 11, 30, 23)) }

  before do
    allow_any_instance_of(FocusNfeApi).to receive(:create)
    allow_any_instance_of(FocusNfeApi).to receive(:get) do
      {
        status: "autorizado"
      }
    end
  end

  describe "reports" do
    context "billed revenue" do
      before do
        bill_1.update(status: :billed)
      end

      it "should return the billed_amount sum" do
        expect(report_service.revenue).to eq 176
      end
    end

    context "completed bookings" do
      before do
        bill_2.bookings.update_all(status: :completed)
        bill_2.update(status: :billed)
      end

      it "should return the count (1) of completed bookings" do
        expect(report_service.completed_bookings).to eq 1
      end
    end

    context "canceled bookings" do
      before do
        bill_1.bookings.first.update(status: :customer_canceled)
      end

      it "should return the count (1) of canceled bookings" do
        expect(report_service.canceled_bookings).to eq 1
      end
    end

    context "absent bookings" do
      before do
        bill_1.bookings.first.update(status: :absent)
        bill_3.bookings.update_all(status: :absent)
      end

      it "should return the count (1) of absent bookings" do
        expect(report_service.absent_bookings).to eq 1
      end
    end

    context "completed bookings per weekday" do
      before do
        bill_1.bookings.first.update(status: :completed)
        bill_2.bookings.update_all(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return an array of hash containing each weeyday -> completed bookings count" do
        expect(report_service.completed_bookings_per_weekday).to eq [{ [1] => 3 }, { [2] => 2 }]
      end
    end

    context "completed services" do
      before do
        bill_1.bookings.first.update(status: :completed)
        bill_2.bookings.update_all(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return an array of hashes containing title of service and the count of its completed" do
        expect(report_service.completed_services).to eq [{ ["Random service 1"] => 2 },
                                                         { ["Random service 2"] => 1 },
                                                         { ["Random service 3"] => 2 }]
      end
    end

    context "completed services per weekday" do
      before do
        bill_1.bookings.first.update(status: :completed)
        bill_2.bookings.update_all(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return the the hash of completed services per weekday" do
        expect(report_service.completed_services_per_weekday).to eq "Random service 1" => { 1 => 2 }, "Random service 2" => { 2 => 1 }, "Random service 3" => { 2 => 1, 1 => 1 }
      end
    end

    context "new customers" do
      before do
        bill_1.bookings.first.update(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return the new customers count with bookings status of completed" do
        expect(report_service.new_customers).to eq 1
      end
    end

    context "recurrent customers" do
      before do
        bill_1.bookings.update_all(status: :completed)
        bill_2.bookings.update_all(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return the recurrent customers count with bookings status of completed" do
        expect(report_service.recurrent_customers).to eq 1
      end
    end

    context "total customers" do
      before do
        bill_1.bookings.update_all(status: :completed)
        bill_2.bookings.update_all(status: :completed)
        bill_3.bookings.update_all(status: :completed)
        bill_4.bookings.update_all(status: :completed)
        bill_5.bookings.update_all(status: :completed)
      end

      it "should return the total customers count with bookings status of completed" do
        expect(report_service.total_customers).to eq 3
      end
    end
  end
end
