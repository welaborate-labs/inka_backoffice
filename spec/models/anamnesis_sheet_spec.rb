require "rails_helper"

RSpec.describe AnamnesisSheet, type: :model do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let(:anamnesis_sheet) { build(:anamnesis_sheet, customer_id: customer.id) }
  let(:invalid) { build(:anamnesis_sheet, title: nil, customer_id: nil) }

  describe "validations" do
    context "presence" do
      context "valid attributes" do
        it { expect(anamnesis_sheet.valid?).to be true }
      end

      context "invalid attributes" do
        before { invalid.valid? }

        it { is_expected.not_to be_valid }
        it { expect(invalid.errors).not_to be_empty }
        it { expect(invalid.errors.attribute_names).to eq %i[customer title] }
        it { expect(invalid.errors.messages.count).to eq 2 }
        it { expect(invalid.errors.messages[:title]).to eq ["não pode ficar em branco"] }
        it { expect(invalid.errors.messages[:customer]).to eq ["é obrigatório(a)"] }
      end
    end
  end
end
