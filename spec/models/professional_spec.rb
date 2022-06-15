require 'rails_helper'

RSpec.describe Professional, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { build(:user, uid: identity.id) }
  let(:professional) { build(:professional, :with_avatar, user: user) }
  let(:schedule_2) { create(:schedule, professional: professional) }
  let(:timeslots) { create_list(:timeslot, 15, schedule: schedule_2) }
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
      expect(invalid.errors.attribute_names).to eq %i[user name email phone address document]
      expect(invalid.errors.messages.count).to eq 6
      expect(invalid.errors.messages[:user]).to eq ["é obrigatório(a)"]
      expect(invalid.errors.messages[:name]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 3 caracteres)"]
      expect(invalid.errors.messages[:email]).to eq ["não pode ficar em branco", "não é válido"]
      expect(invalid.errors.messages[:phone]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 8 caracteres)"]
      expect(invalid.errors.messages[:address]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 10 caracteres)"]
      expect(invalid.errors.messages[:document]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 10 caracteres)"]
    end

    it "should verify the 'email format'" do
      professional = build(:professional, :with_avatar, user: user, email: 'john.doe')
      professional.save
      expect(professional.errors.attribute_names).to eq [:email]
      expect(professional.errors.messages[:email]).to eq ["não é válido"]
    end

    it 'should verify the uniqueness' do
      professional = create(:professional, :with_avatar, user: user)
      invalid = build(:professional, :with_avatar, user: user)
      invalid.save
      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq %i[email document]
      expect(invalid.errors.messages.count).to eq 2
      expect(invalid.errors.messages[:email]).to eq ["já está em uso"]
      expect(invalid.errors.messages[:document]).to eq ["já está em uso"]
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
        expect(professional.errors.messages[:name]).to eq ["é muito curto (mínimo: 3 caracteres)"]
        expect(professional.errors.messages[:phone]).to eq ["é muito curto (mínimo: 8 caracteres)"]
        expect(professional.errors.messages[:address]).to eq ["é muito curto (mínimo: 10 caracteres)"]
        expect(professional.errors.messages[:document]).to eq ["é muito curto (mínimo: 10 caracteres)"]
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
        expect(professional.errors.messages[:name]).to eq ["é muito longo (máximo: 100 caracteres)"]
        expect(professional.errors.messages[:phone]).to eq ["é muito longo (máximo: 15 caracteres)"]
        expect(professional.errors.messages[:address]).to eq ["é muito longo (máximo: 150 caracteres)"]
        expect(professional.errors.messages[:document]).to eq ["é muito longo (máximo: 16 caracteres)"]
      end
    end

    describe 'should verify the timeslots through schedules' do
      it 'should return all timeslots' do
        expect(professional.timeslots).to eq timeslots
        expect(professional.timeslots.count).to eq 15
      end
    end
  end
end
