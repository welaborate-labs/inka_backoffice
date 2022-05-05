require 'rails_helper'

RSpec.describe ServiceBooking, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:schedule) { create(:schedule, professional: professional) }
  let(:customer) { create(:customer, :with_avatar) }
  let(:timeslot) { create(:timeslot, schedule: schedule) }
  let(:service_booking) { build(:service_booking, timeslot: timeslot, customer: customer) }
  let(:invalid) { ServiceBooking.new }

  describe 'instances an empty service book' do
    subject { ServiceBooking.new }
    it { is_expected.to be_a_new ServiceBooking }
  end

  describe 'with valid attributes' do
    subject { service_booking }
    it { is_expected.to be_valid }
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[customer timeslot status]
      expect(invalid.errors.messages.count).to eq 3
      expect(invalid.errors.messages[:customer]).to eq ['must exist']
      expect(invalid.errors.messages[:timeslot]).to eq ['must exist']
      expect(invalid.errors.messages[:status]).to eq ["can't be blank"]
    end
  end
end
