require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:schedule) { build(:schedule, professional: professional) }
  let(:schedule_2) { create(:schedule, professional: professional) }
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
      expect(invalid.errors.attribute_names).to eq %i[professional weekday starts_at ends_at interval_starts_at interval_ends_at]
      expect(invalid.errors.messages.count).to eq 6
      expect(invalid.errors.messages[:professional]).to eq ["é obrigatório(a)"]
      expect(invalid.errors.messages[:weekday]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:starts_at]).to eq ["não pode ficar em branco", "não está incluído na lista"]
      expect(invalid.errors.messages[:ends_at]).to eq ["não pode ficar em branco", "não está incluído na lista"]
      expect(invalid.errors.messages[:interval_starts_at]).to eq ["não pode ficar em branco", "não está incluído na lista"]
      expect(invalid.errors.messages[:interval_ends_at]).to eq ["não pode ficar em branco", "não está incluído na lista"]
    end

    it "should verify the interval 'presence'" do
      schedule.interval_ends_at = nil
      schedule.save
      expect(schedule.errors.attribute_names).to eq %i[interval_ends_at]
      expect(schedule.errors.messages.count).to eq 1
      expect(schedule.errors.messages[:interval_ends_at]).to eq ["não pode ficar em branco", "não está incluído na lista"]
    end

    it "should verify the 'format' (00:00 to 23:00)" do
      schedule.starts_at = '99'
      schedule.ends_at = '99'
      schedule.interval_starts_at = '99'
      schedule.interval_ends_at = '99'
      schedule.save
      expect(schedule.errors.attribute_names).to eq %i[
           starts_at
           ends_at
           interval_starts_at
           interval_ends_at
         ]
      expect(schedule.errors.messages[:starts_at]).to eq ["não está incluído na lista"]
      expect(schedule.errors.messages[:ends_at]).to eq ["não está incluído na lista"]
      expect(schedule.errors.messages[:interval_starts_at]).to eq ["não está incluído na lista"]
      expect(schedule.errors.messages[:interval_ends_at]).to eq ["não está incluído na lista"]
    end
  end
end
