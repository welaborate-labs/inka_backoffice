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

  describe 'validations' do
    it 'should verify presence' do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.messages[:provider]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:uid]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:email]).to eq ["não pode ficar em branco", "não é válido"]
      expect(invalid.errors.messages[:name]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 3 caracteres)"]
    end

    it "should verify the 'email format'" do
      user = build(:user, email: 'john.doe')
      user.save
      expect(user.errors.attribute_names).to eq [:email]
      expect(user.errors.messages[:email]).to eq ["não é válido"]
    end

    it 'should verify the uniqueness' do
      user = create(:user)
      invalid = build(:user, email: user.email)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq [:email]
      expect(invalid.errors.messages.count).to eq 1
      expect(invalid.errors.messages[:email]).to eq ["já está em uso"]
    end

    describe "should verify the 'length'" do
      it 'should verify the mimimum ' do
        user = build(:user, phone: '123', name: 'ab')
        user.save
        expect(user.errors.messages.count).to be 2
        expect(user.errors.attribute_names).to eq %i[phone name]
        expect(user.errors.messages[:phone]).to eq ["é muito curto (mínimo: 8 caracteres)"]
        expect(user.errors.messages[:name]).to eq ["é muito curto (mínimo: 3 caracteres)"]
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
        expect(user.errors.messages[:phone]).to eq ["é muito longo (máximo: 15 caracteres)"]
        expect(user.errors.messages[:name]).to eq ["é muito longo (máximo: 100 caracteres)"]
      end
    end
  end
end
