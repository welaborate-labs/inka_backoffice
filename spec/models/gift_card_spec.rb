require 'rails_helper'

RSpec.describe GiftCard, type: :model do
  let(:gift_card) { build(:gift_card) }
  let(:invalid_gift_card) { GiftCard.new }

  describe "validations" do
    before { invalid_gift_card.valid? }

    context "attributes" do
      subject { invalid_gift_card.errors.attribute_names }

      it { is_expected.to include :customer }
    end

    context "messages" do
      describe "customer" do
        subject { invalid_gift_card.errors.messages[:customer] }

        it { is_expected.to eq ["é obrigatório(a)"] }
      end
    end
  end

  describe "with valid attributes" do
    subject { gift_card }
    before { gift_card.valid? }

    it { is_expected.to be_valid }
  end
end
