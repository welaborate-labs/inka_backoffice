require 'rails_helper'

RSpec.describe Identity, type: :model do
  let(:identity) { build(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:invalid) { Identity.new }

  describe 'instances an empty user' do
    subject { Identity.new }
    it { is_expected.to be_a_new Identity }
  end

  describe 'with valid attributes' do
    subject { identity }
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
      expect(invalid.errors.attribute_names).to eq %i[password email name phone]
      expect(invalid.errors.messages.count).to eq 4
      expect(invalid.errors.messages[:password]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:email]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:name]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:phone]).to eq ["não pode ficar em branco"]
    end

    it 'should verify the uniqueness' do
      idendity = create(:identity)
      invalid = build(:identity, email: identity.email)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq [:email]
      expect(invalid.errors.messages.count).to eq 1
      expect(invalid.errors.messages[:email]).to eq ["já está em uso"]
    end
  end
end
