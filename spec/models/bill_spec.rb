require 'rails_helper'

RSpec.describe Bill, type: :model do
  let!(:schedule) { create(:schedule, professional_id: professional.id)}
  let(:professional) { create(:professional)}
  let(:booking) { create(:booking, professional_id: professional.id) }
  let(:bill) { build(:bill, bookings: [booking]) }

  let(:invalid_bill) { Bill.new }

  describe "validations" do
    before { invalid_bill.valid? }

    context "attributes" do
      subject { invalid_bill.errors.attribute_names }

      it { is_expected.to include :bookings }
    end

    context "messages" do
      describe "bookings" do
        subject { invalid_bill.errors.messages[:bookings] }

        it { is_expected.to eq ["não pode ficar em branco."] }
      end
    end
  end

  describe "with valid attributes" do
    subject { bill }
    before { bill.valid? }

    it { is_expected.to be_valid }
  end
end
