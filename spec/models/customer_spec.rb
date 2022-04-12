require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:customer) { build(:customer, :with_avatar) }
  let(:invalid) { Customer.new }

  describe 'instances an empty customer' do
    subject { Customer.new }
    it { is_expected.to be_a_new Customer }
  end

  describe 'with valid attributes' do
    subject { customer }
    it { is_expected.to be_valid }
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[name email phone address document avatar]
      expect(invalid.errors.messages.count).to eq 6
      expect(invalid.errors.messages[:name]).to eq [
           "can't be blank",
           'is too short (minimum is 3 characters)'
         ]
      expect(invalid.errors.messages[:email]).to eq ["can't be blank", 'is invalid']
      expect(invalid.errors.messages[:phone]).to eq [
           "can't be blank",
           'is too short (minimum is 8 characters)'
         ]
      expect(invalid.errors.messages[:address]).to eq [
           "can't be blank",
           'is too short (minimum is 10 characters)'
         ]
      expect(invalid.errors.messages[:document]).to eq [
           "can't be blank",
           'is too short (minimum is 10 characters)'
         ]
      expect(invalid.errors.messages[:avatar]).to eq ["can't be blank"]
    end

    it "should verify the 'email format'" do
      customer = build(:customer, :with_avatar, email: 'john.doe')
      customer.save
      expect(customer.errors.attribute_names).to eq [:email]
      expect(customer.errors.messages[:email]).to eq ['is invalid']
    end

    it 'should verify the uniqueness' do
      customer = create(:customer, :with_avatar)
      invalid = build(:customer, :with_avatar)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq %i[email document]
      expect(invalid.errors.messages.count).to eq 2
      expect(invalid.errors.messages[:email]).to eq ['has already been taken']
      expect(invalid.errors.messages[:document]).to eq ['has already been taken']
    end

    describe "should verify the 'length'" do
      it 'should verify the mimimum' do
        customer =
          build(
            :customer,
            :with_avatar,
            name: 'ab',
            phone: '1234567',
            address: '123456789',
            document: '123456789'
          )
        customer.save
        expect(customer.errors.messages.count).to be 4
        expect(customer.errors.attribute_names).to eq %i[name phone address document]
        expect(customer.errors.messages[:name]).to eq ['is too short (minimum is 3 characters)']
        expect(customer.errors.messages[:phone]).to eq ['is too short (minimum is 8 characters)']
        expect(customer.errors.messages[:address]).to eq [
             'is too short (minimum is 10 characters)'
           ]
        expect(customer.errors.messages[:document]).to eq [
             'is too short (minimum is 10 characters)'
           ]
      end

      it "should verify the 'maximum'" do
        customer =
          build(
            :customer,
            :with_avatar,
            name:
              'abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde',
            phone: '1234567890123456',
            address:
              'abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde',
            document: '123456789012345678'
          )
        customer.save
        expect(customer.errors.messages.count).to be 4
        expect(customer.errors.attribute_names).to eq %i[name phone address document]
        expect(customer.errors.messages[:name]).to eq ['is too long (maximum is 100 characters)']
        expect(customer.errors.messages[:phone]).to eq ['is too long (maximum is 15 characters)']
        expect(customer.errors.messages[:address]).to eq [
             'is too long (maximum is 150 characters)'
           ]
        expect(customer.errors.messages[:document]).to eq [
             'is too long (maximum is 16 characters)'
           ]
      end
    end
  end
end
