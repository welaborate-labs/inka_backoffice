require 'rails_helper'

RSpec.describe ProductUsage, type: :model do
  let(:user) { create(:user) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:service) { create(:service, professional: professional) }
  let(:product) { create(:product) }
  let(:product_usage) { create(:product_usage, product: product, service: service) }
  let(:invalid_product) { ProductUsage.new }

  describe 'validations' do
    context 'should verify the presence' do
      context 'with valid attributes' do
        it { expect(product_usage.valid?).to be true }
      end

      context 'with invalid attributes' do
        before { invalid_product.valid? }

        it { expect(invalid_product.errors).not_to be_empty }
        it { expect(invalid_product.errors.count).to eq 3 }
        it { expect(invalid_product.errors.attribute_names).to eq %i[product service quantity] }
        it { expect(invalid_product.errors.messages[:product]).to eq ["é obrigatório(a)"] }
        it { expect(invalid_product.errors.messages[:service]).to eq ["é obrigatório(a)"] }
        it { expect(invalid_product.errors.messages[:quantity]).to eq ["não pode ficar em branco"] }
      end
    end
  end
end
