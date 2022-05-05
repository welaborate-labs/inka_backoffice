require 'rails_helper'

RSpec.describe GenerateTimeslotsCommand, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:starts_at) { DateTime.new(2022, 5, 2, 00) }
  let(:ends_at) { DateTime.new(2022, 5, 7, 00) }
  let(:generateTimeslots) { GenerateTimeslotsCommand.new(starts_at: starts_at, ends_at: ends_at) }

  before { 5.times { |n| create(:schedule, professional: professional, weekday: n + 1) } }

  describe '#initialize' do
    subject { generateTimeslots }

    it { is_expected.to have_attributes(starts_at: starts_at, ends_at: ends_at) }
  end

  describe '#run' do
    subject { generateTimeslots.run }

    context 'should create #60 timeslots' do
      it { expect { subject }.to change(Timeslot, :count).by(50) }
    end

    context 'should not create timeslots' do
      before { generateTimeslots.run }

      it { expect { subject }.not_to change(Timeslot, :count) }
    end

    context 'should create #20 more timeslots' do
      before { generateTimeslots.run }

      it do
        expect {
          GenerateTimeslotsCommand.new(
            starts_at: DateTime.new(2022, 5, 9, 00),
            ends_at: DateTime.new(2022, 5, 10, 00)
          ).run
        }.to change(Timeslot, :count).by(20)
      end
    end

    context 'should create #10 more timeslots for each day' do
      before { generateTimeslots.run }

      it do
        expect {
          GenerateTimeslotsCommand.new(
            starts_at: starts_at,
            ends_at: DateTime.new(2022, 5, 10, 00)
          ).run
        }.to change(Timeslot, :count).by(20)
      end
    end
  end

  describe '#rollback' do
    context 'should destroy all created timeslots #-50' do
      before { generateTimeslots.run }
      it { expect { generateTimeslots.rollback }.to change(Timeslot, :count).by(-50) }
    end
  end
end
