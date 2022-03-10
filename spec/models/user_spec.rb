require 'rails_helper'

RSpec.describe User, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:invalid) { User.new }

  describe 'instances an empty user' do
    subject { User.new }
    it { is_expected.to be_a_new User }
  end

  describe 'with valid attributes' do
    subject { user }
    it { is_expected.to be_valid }
  end

  describe 'should exist the identity for it' do
    before { user.save! }
    it { expect(user.uid).to eq identity.id }
    it { expect(Identity.find(user.uid)).to eq identity }
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[provider uid email name phone]
      expect(invalid.errors.messages.count).to eq 5
      expect(invalid.errors.messages[:provider]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:uid]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:email]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:name]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:phone]).to eq ["can't be blank"]
    end

    it "should verify the 'email format'" do
      user = build(:user, email: 'john.doe')
      user.save
      expect(user.errors.attribute_names).to eq [:email]
      expect(user.errors.messages[:email]).to eq ['is invalid']
    end

    it 'should verify the uniqueness' do
      user = create(:user)
      invalid = build(:user, email: user.email)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq [:email]
      expect(invalid.errors.messages.count).to eq 1
      expect(invalid.errors.messages[:email]).to eq ['has already been taken']
    end

    describe "should verify the 'length'" do
      it 'should verify the mimimum ' do
        user = build(:user, phone: '123', name: 'ab')
        user.save
        expect(user.errors.messages.count).to be 2
        expect(user.errors.attribute_names).to eq %i[phone name]
        expect(user.errors.messages[:phone]).to eq ['is too short (minimum is 8 characters)']
        expect(user.errors.messages[:name]).to eq ['is too short (minimum is 3 characters)']
      end

      it "should verify the 'maximum'" do
        user =
          build(
            :user,
            phone: '1234567890987654',
            name:
              'abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
                 abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde'
          )
        user.save
        expect(user.errors.messages.count).to be 2
        expect(user.errors.attribute_names).to eq %i[phone name]
        expect(user.errors.messages[:phone]).to eq ['is too long (maximum is 15 characters)']
        expect(user.errors.messages[:name]).to eq ['is too long (maximum is 100 characters)']
      end
    end
  end

  describe 'hooks' do
    let(:user) { build(:user, name: 'joHn dOe') }
    it 'should capitalize on create' do
      user.save
      expect(user.name).to eq 'John Doe'
    end

    it 'should capitalize on update' do
      user.save
      user.name = 'john doe'
      user.save
      expect(user.name).to eq 'John Doe'
    end
  end
end
