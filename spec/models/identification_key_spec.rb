require 'rails_helper'

RSpec.describe IdentificationKey, type: :model do
  let(:identification_key) { build(:identification_key) }
  let(:public_key) { OpenSSL::PKey::RSA.new(identification_key.private_key).public_key.to_pem }
  let(:invalid) { IdentificationKey.new }

  describe 'instances an empty identification key' do
    subject { IdentificationKey.new }
    it { is_expected.to be_a_new IdentificationKey }
  end

  describe 'with valid attributes' do
    subject { identification_key }
    it { is_expected.to be_valid }
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe '#public_key' do
    subject { identification_key.public_key }
    it { is_expected.to eq public_key }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[private_key]
      expect(invalid.errors.messages.count).to eq 1
      expect(invalid.errors.messages[:private_key]).to eq ["can't be blank"]
    end
  end
end
