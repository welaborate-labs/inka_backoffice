require 'rails_helper'

RSpec.describe Timeslot, type: :model do
  let(:identity) { build(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:professional) { build(:professional, :with_avatar, user: user) }
  let(:schedule) { build(:schedule, professional: professional) }
  let(:timeslot) { build(:timeslot, schedule: schedule) }
  let(:invalid) { Timeslot.new }

  describe 'instances an empty schedule' do
    subject { Timeslot.new }
    it { is_expected.to be_a_new Timeslot }
  end

  describe 'with valid attributes' do
    subject { timeslot }
    it { is_expected.to be_valid }
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      # invalid value to DATETIME sets automatically to nil
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[schedule starts_at ends_at]
      expect(invalid.errors.messages.count).to eq 3
      expect(invalid.errors.messages[:schedule]).to eq ['must exist']
      expect(invalid.errors.messages[:starts_at]).to eq ["can't be blank or is invalid"]
      expect(invalid.errors.messages[:ends_at]).to eq ["can't be blank or is invalid"]
    end
  end
end