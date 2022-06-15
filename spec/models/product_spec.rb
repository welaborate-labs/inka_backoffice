require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }
  let(:stock) { create(:stock, type: 'StockIncrement', product: product) }
  let(:invalid_product) { Product.new }

  describe 'validations' do
    context 'should verify the presence' do
      before { invalid_product.valid? }

      it { expect(invalid_product.errors).not_to be_empty }
      it { expect(invalid_product.errors.count).to eq 3 }
      it { expect(invalid_product.errors.attribute_names).to eq %i[name sku unit] }
      it { expect(invalid_product.errors.messages[:name]).to eq ["não pode ficar em branco"] }
      it { expect(invalid_product.errors.messages[:sku]).to eq ["não pode ficar em branco"] }
      it { expect(invalid_product.errors.messages[:unit]).to eq ["não pode ficar em branco"] }
    end
  end
end
