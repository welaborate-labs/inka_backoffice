require 'rails_helper'

RSpec.describe Bill, type: :model do
  let!(:schedule) { create(:schedule, professional_id: professional.id)}
  let(:professional) { create(:professional)}
  let(:booking) { create(:booking, professional_id: professional.id) }

  let(:bill) { create(:bill, bookings: [booking]) }

  let(:invalid_bill) { Bill.new }
  let(:invalid_bill_2) { build(:bill, bookings: [booking]) }

  before do
    allow_any_instance_of(FocusNfeApi).to receive(:create)
    allow_any_instance_of(FocusNfeApi).to receive(:get) do
      {
        status: "autorizado"
      }
    end
  end

  describe "validations" do
    describe "booking_ids presence" do
      it "without booking_ids" do
        expect(invalid_bill).not_to be_valid
        expect(invalid_bill.errors.attribute_names).to include(:bookings)
        expect(invalid_bill.errors.messages[:bookings]).to eq(["não pode ficar em branco"])
      end
    end

    describe "#duplicated" do
      it "has Bookings that are already Billed" do
        expect(invalid_bill_2).not_to be_valid
        expect(invalid_bill_2.errors.attribute_names).to include(:bookings)
        expect(invalid_bill_2.errors.messages[:bookings]).to eq(["Serviços já fechados. Cancele a nota fiscal gerada antes de tentar novamente."])
      end
    end
  end

  describe "with valid attributes" do
    subject { bill }

    it { is_expected.to be_valid }
  end

  describe "billing_or_billed scope" do
    let(:billing_or_billed) { Bill.billing_or_billed }

    it "should return billings bookings" do
      expect(billing_or_billed).to eq [bill]
    end

    it "should return empty" do
      bill.update status: :billing_canceled

      expect(billing_or_billed).to eq []
    end
  end
end
