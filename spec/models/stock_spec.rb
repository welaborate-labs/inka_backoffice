require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:product) { create(:product) }

  describe 'STI with StockIncrement and StockDecrement' do
    let(:stock) { create(:stock, type: type, product: product) }

    subject { Stock.find(stock.id) }

    context 'when type is StockIncrement' do
      let(:type) { 'StockIncrement' }

      it { is_expected.to be_a(StockIncrement) }
    end

    describe 'polymorphs as StockDecrement' do
      let(:type) { 'StockDecrement' }

      it { is_expected.to be_a(StockDecrement) }
    end
  end

  describe 'validations' do
    let(:invalid_stock) { Stock.new }

    before { invalid_stock.valid? }

    context 'should verify the presence' do
      it { expect(invalid_stock.errors.empty?).to be false }
      it do
        expect(invalid_stock.errors.attribute_names).to eq %i[
             product
             type
             quantity
             integralized_at
           ]
      end
      it { expect(invalid_stock.errors.messages.count).to eq 4 }
      it { expect(invalid_stock.errors.messages[:product]).to eq ['must exist'] }
      it { expect(invalid_stock.errors.messages[:type]).to eq ["can't be blank"] }
      it { expect(invalid_stock.errors.messages[:quantity]).to eq ["can't be blank"] }
      it { expect(invalid_stock.errors.messages[:integralized_at]).to eq ["can't be blank"] }
    end
  end

  describe 'should verify the #balance_change' do
    let(:stock) { create(:stock, type: type, product: product) }

    context 'when type is Stock' do
      let(:type) { 'Stock' }

      it 'returns NotImplementedError' do
        expect { stock.balance_change }.to raise_error NotImplementedError
      end
    end

    context 'when type is StockIncrement' do
      let(:type) { 'StockIncrement' }

      subject { StockIncrement.find(stock.id) }

      it 'returns the quantity plus 1' do
        is_expected.to change { stock.quantity }.by(1)
      end
    end

    context 'when StockDecrement' do
      let(:type) { 'StockDecrement' }

      it 'returns the quantity less 1' do
        expect { stock.balance_change }.to change { stock.quantity }.by(-1)
      end
    end
  end
end
