require 'rails_helper'

RSpec.describe GiftCardTemplate, type: :model do
  let(:gift_card_template) { build(:gift_card_template) }
  let(:invalid_gift_card_template) { GiftCardTemplate.new }

  describe "validations" do
    before { invalid_gift_card_template.valid? }

    context "attributes" do
      subject { invalid_gift_card_template.errors.attribute_names }

      it { is_expected.to include :name }
      it { is_expected.to include :price }
    end

    context "messages" do
      describe "name" do
        subject { invalid_gift_card_template.errors.messages[:name] }

        it { is_expected.to eq ["não pode ficar em branco"]}
      end

      describe "price" do
        subject { invalid_gift_card_template.errors.messages[:price] }

        it { is_expected.to eq ["não pode ficar em branco"] }
      end
    end
  end

  describe "with valid attributes" do
    subject { gift_card_template }
    before { gift_card_template.valid? }

    it { is_expected.to be_valid }
  end
end
