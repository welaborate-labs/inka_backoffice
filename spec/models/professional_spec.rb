require 'rails_helper'

RSpec.describe Professional, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:professional) { build(:professional, :with_avatar, user: user) }
  let(:invalid) { Professional.new }

  describe 'instances an empty professional' do
    subject { Professional.new }
    it { is_expected.to be_a_new Professional }
  end

  describe 'with valid attributes' do
    subject { professional }
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
      expect(invalid.errors.attribute_names).to eq %i[
           user
           name
           email
           phone
           address
           document
           avatar
         ]
      expect(invalid.errors.messages.count).to eq 7
      expect(invalid.errors.messages[:user]).to eq ['must exist']
      expect(invalid.errors.messages[:name]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:email]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:phone]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:address]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:document]).to eq ["can't be blank"]
      expect(invalid.errors.messages[:avatar]).to eq ["can't be blank"]
    end

    it "should verify the 'email format'" do
      professional = build(:professional, :with_avatar, user: user, email: 'john.doe')
      professional.save
      expect(professional.errors.attribute_names).to eq [:email]
      expect(professional.errors.messages[:email]).to eq ['is invalid']
    end

    it 'should verify the uniqueness' do
      professional = create(:professional, :with_avatar, user: user)
      invalid = build(:professional, :with_avatar, user: user)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq %i[email document]
      expect(invalid.errors.messages.count).to eq 2
      expect(invalid.errors.messages[:email]).to eq ['has already been taken']
      expect(invalid.errors.messages[:document]).to eq ['has already been taken']
    end

    describe "should verify the 'length'" do
      it 'should verify the mimimum' do
        professional =
          build(
            :professional,
            :with_avatar,
            user: user,
            name: 'ab',
            phone: '1234567',
            address: '123456789',
            document: '123456789'
          )
        professional.save
        expect(professional.errors.messages.count).to be 4
        expect(professional.errors.attribute_names).to eq %i[name phone address document]
        expect(professional.errors.messages[:name]).to eq [
             'is too short (minimum is 3 characters)'
           ]
        expect(professional.errors.messages[:phone]).to eq [
             'is too short (minimum is 8 characters)'
           ]
        expect(professional.errors.messages[:address]).to eq [
             'is too short (minimum is 10 characters)'
           ]
        expect(professional.errors.messages[:document]).to eq [
             'is too short (minimum is 10 characters)'
           ]
      end

      it "should verify the 'maximum'" do
        professional =
          build(
            :professional,
            :with_avatar,
            user: user,
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
        professional.save
        expect(professional.errors.messages.count).to be 4
        expect(professional.errors.attribute_names).to eq %i[name phone address document]
        expect(professional.errors.messages[:name]).to eq [
             'is too long (maximum is 100 characters)'
           ]
        expect(professional.errors.messages[:phone]).to eq [
             'is too long (maximum is 15 characters)'
           ]
        expect(professional.errors.messages[:address]).to eq [
             'is too long (maximum is 150 characters)'
           ]
        expect(professional.errors.messages[:document]).to eq [
             'is too long (maximum is 16 characters)'
           ]
      end
    end
  end
end
