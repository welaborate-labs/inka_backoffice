require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:customer) { create(:customer, :with_avatar) }
  let(:professional) { create(:professional) }
  let(:schedule_1) { create(:schedule, professional: professional) }
  let(:schedule_2) { create(:schedule, professional: professional) }
  let(:schedule_3) { create(:schedule, professional: professional) }

  let!(:timeslot_1) do
    create(
      :timeslot,
      schedule: schedule_1,
      starts_at: '2022-05-10 09:00',
      ends_at: '2022-05-10 09:30'
    )
  end
  let!(:timeslot_2) do
    create(
      :timeslot,
      schedule: schedule_2,
      starts_at: '2022-05-10 09:30',
      ends_at: '2022-05-10 10:00'
    )
  end
  let!(:timeslot_3) do
    create(
      :timeslot,
      schedule: schedule_3,
      starts_at: '2022-05-10 10:00',
      ends_at: '2022-05-10 10:30'
    )
  end

  let(:service) { create(:service, professional: professional) }
  let(:booking) do
    build(
      :booking,
      customer: customer,
      service: service,
      booking_datetime: '2022-05-10 09:00'
    )
  end

  let(:invalid_booking) { Booking.new }

  describe 'valitations' do
    subject { booking }

    context "should verify the 'presence'" do
      before { invalid_booking.valid? }

      it do
        expect(invalid_booking.errors.attribute_names).to eq %i[
             customer
             service
             status
             booking_datetime
           ]
      end
      it { expect(invalid_booking.errors.messages.count).to eq 4 }
      it { expect(invalid_booking.errors.messages[:customer]).to eq ["é obrigatório(a)"] }
      it { expect(invalid_booking.errors.messages[:service]).to eq ["é obrigatório(a)"] }
      it { expect(invalid_booking.errors.messages[:status]).to eq ["não pode ficar em branco"] }
      it do
        expect(invalid_booking.errors.messages[:booking_datetime]).to eq ["não pode ficar em branco"]
      end
    end

    context 'service with 30 minutes and available timeslots' do
      it { is_expected.to be_valid }
    end

    context 'service with 30 minutes and not available timeslots' do
      subject { booking_2 }

      let!(:booking) do
        create(
          :booking,
          customer: customer,
          service: service,
          booking_datetime: '2022-05-10 09:00'
        )
      end

      let(:booking_2) do
        build(
          :booking,
          customer: customer,
          service: service,
          booking_datetime: '2022-05-10 09:00'
        )
      end

      it { is_expected.not_to be_valid }
    end

    context 'service with 60 minutes and available timeslots' do
      let(:service) { create(:service, professional: professional, duration: 60) }

      it { is_expected.to be_valid }
    end

    context 'service with 60 minutes and not available timeslots' do
      subject { booking_2 }

      let(:service) { create(:service, professional: professional, duration: 60) }
      let!(:booking) do
        create(
          :booking,
          customer: customer,
          service: service,
          booking_datetime: '2022-05-10 09:30'
        )
      end

      let(:booking_2) do
        build(
          :booking,
          customer: customer,
          service: service,
          booking_datetime: '2022-05-10 10:25'
        )
      end

      it { is_expected.not_to be_valid }
    end

    context 'service with 45 minutes and available timeslots' do
      let(:service) { create(:service, professional: professional, duration: 45) }

      it { is_expected.to be_valid }
    end

    context 'service with 45 minutes and not available timeslots' do
      let(:service) { create(:service, professional: professional, duration: 45) }

      let(:booking) do
        build(
          :booking,
          customer: customer,
          service: service,
          booking_datetime: '2022-05-10 11:00'
        )
      end

      it { is_expected.not_to be_valid }
    end

    context 'service with 30mins and optional service' do
      subject { service_2 }
      let(:service_2) do
        create(:service, professional: professional, duration: 30, optional_services: [service])
      end

      it { is_expected.to be_valid }
    end

    context 'service with 30mins and 30mins from optional service but not available timeslots' do
      subject { booking }
      let(:service_2) do
        create(:service, professional: professional, duration: 30, optional_services: [service])
      end

      let(:booking) do
        build(
          :booking,
          customer: customer,
          service: service_2,
          booking_datetime: '2022-05-10 11:00'
        )
      end

      it { is_expected.not_to be_valid }
    end

    context 'service with 45mins and optional service' do
      subject { service_2 }
      let(:service_2) do
        create(:service, professional: professional, duration: 15, optional_services: [service])
      end

      it { is_expected.to be_valid }
    end

    context 'service with 30min and 30mins from optional service but not available timeslots' do
      subject { booking }
      let(:service_2) do
        create(:service, professional: professional, duration: 30, optional_services: [service])
      end

      let(:booking) do
        build(
          :booking,
          customer: customer,
          service: service_2,
          booking_datetime: '2022-05-10 11:00'
        )
      end

      it { is_expected.not_to be_valid }
    end

    context 'service with 65mins and optional service' do
      subject { service_2 }
      let(:service_2) do
        create(:service, professional: professional, duration: 45, optional_services: [service])
      end

      it { is_expected.to be_valid }
    end

    context 'service with 30min and 45mins from optional service and available timeslots' do
      subject { booking }
      let(:service_2) do
        create(:service, professional: professional, duration: 45, optional_services: [service])
      end

      let(:booking) do
        build(
          :booking,
          customer: customer,
          service: service_2,
          booking_datetime: '2022-05-10 09:00'
        )
      end

      it { is_expected.to be_valid }
    end

    context 'service with 30min and 45mins from optional service but not available timeslots' do
      subject { booking }
      let(:service_2) do
        create(:service, professional: professional, duration: 45, optional_services: [service])
      end

      let(:booking) do
        build(
          :booking,
          customer: customer,
          service: service_2,
          booking_datetime: '2022-05-10 09:30'
        )
      end

      it { is_expected.not_to be_valid }
    end
  end
end
