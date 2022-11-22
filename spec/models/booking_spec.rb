require "rails_helper"

RSpec.describe Booking, type: :model do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let(:professional) { create(:professional, user_id: user.id) }
  let!(:schedule_1) { create(:schedule, professional: professional) }
  let!(:schedule_2) { create(:schedule, professional: professional, weekday: 2) }
  let!(:schedule_3) { create(:schedule, professional: professional, weekday: 3) }

  let(:service) { create(:service) }
  let(:occupation) { create(:occupation, service: service, professional: professional) }

  let(:booking) { build(:booking, customer: customer, service: service, professional: professional, starts_at: "2022-05-10 15:00") }

  let(:invalid_booking) { Booking.new }

  describe "validations" do
    before { invalid_booking.valid? }

    describe "attributes" do
      subject { invalid_booking.errors.attribute_names }

      it { is_expected.to include :customer }
      it { is_expected.to include :service }
      it { is_expected.to include :status }
      it { is_expected.to include :starts_at }
      it { is_expected.to include :ends_at }
      it { is_expected.to include :professional }
    end

    describe "messages" do
      describe "customer" do
        subject { invalid_booking.errors.messages[:customer] }

        it { is_expected.to eq ["é obrigatório(a)"] }
      end

      describe "service" do
        subject { invalid_booking.errors.messages[:service] }

        it { is_expected.to eq ["é obrigatório(a)"] }
      end

      describe "status" do
        subject { invalid_booking.errors.messages[:status] }
        it { is_expected.to eq ["não pode ficar em branco"] }
      end

      describe "starts_at" do
        subject { invalid_booking.errors.messages[:starts_at] }

        it { is_expected.to eq ["não pode ficar em branco"] }
      end

      describe "ends_at" do
        subject { invalid_booking.errors.messages[:ends_at] }

        it { is_expected.to eq ["não pode ficar em branco"] }
      end
    end

    describe "professional_is_available" do
      let(:other_service) { create(:service, duration: service_duration) }
      let!(:previous_booking) { create(:booking, customer: customer, service: other_service, professional: professional, starts_at: starts_at) }

      subject { booking }

      context "with available professional" do
        let(:service_duration) { 60 }
        let(:starts_at) { "2022-05-10 10:00" }

        it { is_expected.to be_valid }
      end

      context "with booked professional before booking starts and after booking ends" do
        let(:service_duration) { 90 }
        let(:starts_at) { "2022-05-10 14:45" }

        it { is_expected.not_to be_valid }
      end

      context "with booked professional before booking starts and before booking ends" do
        let(:service_duration) { 45 }
        let(:starts_at) { "2022-05-10 14:30" }

        it { is_expected.not_to be_valid }
      end

      context "with booked professional after booking starts and after booking ends" do
        let(:service_duration) { 60 }
        let(:starts_at) { "2022-05-10 14:30" }

        it { is_expected.not_to be_valid }
      end

      context "with booked professional after booking starts and before booking ends" do
        let(:service_duration) { 15 }
        let(:starts_at) { "2022-05-10 15:30" }

        it { is_expected.not_to be_valid }
      end

      context "with canceled booked professional before booking starts and after booking ends" do
        let(:service_duration) { 120 }
        let(:starts_at) { "2022-05-10 16:00" }

        before { previous_booking.update(status: :customer_canceled) }

        it { is_expected.to be_valid }
      end

      context 'with booked professional after booking ends and the same last minute' do
        let(:service_duration) { 30 }
        let(:starts_at) { "2022-05-10 14:30" }

        it { is_expected.to be_valid }
      end

      context 'with booked professional after booking ends and more one minute' do
        let(:service_duration) { 30 }
        let(:starts_at) { "2022-05-10 14:31" }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
