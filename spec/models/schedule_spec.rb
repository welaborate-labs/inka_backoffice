require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:identity) { build(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:professional) { build(:professional, :with_avatar, user: user) }
  let(:schedule) { build(:schedule, professional: professional) }
  let(:invalid) { Schedule.new }

  describe 'instances an empty schedule' do
    subject { Schedule.new }
    it { is_expected.to be_a_new Schedule }
  end

  describe 'with valid attributes' do
    subject { schedule }
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
      expect(invalid.errors.attribute_names).to eq %i[professional weekday starts_at ends_at]
      expect(invalid.errors.messages.count).to eq 4
      expect(invalid.errors.messages[:professional]).to eq ['must exist']
      expect(invalid.errors.messages[:weekday]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:starts_at]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:ends_at]).to eq ["can't be blank"]
    end

    it "should verify the interval 'presence'" do
      schedule.interval_ends_at = nil
      schedule.save
      expect(schedule.errors.attribute_names).to eq %i[interval_ends_at]
      expect(schedule.errors.messages.count).to eq 1
      expect(schedule.errors.messages[:interval_ends_at]).to eq ["can't be blank"]
    end

    describe "should verify the 'length'" do
      it "should verify the 'maximum'" do
        schedule =
          build(
            :schedule,
            weekday: 1,
            starts_at: 'abcde abcde abcde',
            ends_at: 'abcde abcde abcde',
            interval_starts_at: 'abcde abcde abcde',
            interval_ends_at: 'abcde abcde abcde',
            professional: professional
          )
        schedule.save
        expect(schedule.errors.messages.count).to be 4
        expect(schedule.errors.attribute_names).to eq %i[
             starts_at
             ends_at
             interval_starts_at
             interval_ends_at
           ]
        expect(schedule.errors.messages[:starts_at]).to eq [
             'is too long (maximum is 15 characters)'
           ]
        expect(schedule.errors.messages[:ends_at]).to eq ['is too long (maximum is 15 characters)']
        expect(schedule.errors.messages[:interval_starts_at]).to eq [
             'is too long (maximum is 15 characters)'
           ]
        expect(schedule.errors.messages[:interval_ends_at]).to eq [
             'is too long (maximum is 15 characters)'
           ]
      end
    end
  end
end
