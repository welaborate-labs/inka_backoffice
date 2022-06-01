require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:product) { create(:product) }

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

  describe 'verify the balance_change used in the product' do
    let(:stock) { create(:stock, type: type, product: product) }

    subject { Stock.find(stock.id) }

    context 'when type is Stock' do
      let(:type) { 'Stock' }

      it 'returns NotImplementedError' do
        expect { stock.balance_change }.to raise_error NotImplementedError
      end
    end

    context 'when type is StockIncrement' do
      let(:type) { 'StockIncrement' }

      it 'returns positive 1' do
        expect(subject.balance_change).to eq 1
      end
    end

    context 'when StockDecrement' do
      let(:type) { 'StockDecrement' }

      it 'returns negative 1' do
        expect(subject.balance_change).to eq -1
      end
    end
  end

  describe 'verify the scopes for Increments/Decremtens' do
    let(:stock_increment) { create(:stock, type: 'StockIncrement', product: product) }
    let(:stock_decrement) { create(:stock, type: 'StockDecrement', product: product) }

    context 'should return all the stocks' do
      subject { Stock.all }

      it { is_expected.to include(stock_increment, stock_decrement) }
    end

    context 'should return only the stockIncrements' do
      subject { Stock.stock_increments }

      it { is_expected.to include(stock_increment) }
      it { is_expected.not_to include(stock_decrement) }
    end

    context 'should return only the stockDecrements' do
      subject { Stock.stock_decrements }

      it { is_expected.to include(stock_decrement) }
      it { is_expected.not_to include(stock_increment) }
    end
  end
end
