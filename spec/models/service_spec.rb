require 'rails_helper'

RSpec.describe Service, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:professional) { create(:professional, :with_avatar, user: user) }
  let(:service) { build(:service, professional: professional) }
  let(:main_service) { create(:service, professional: professional) }
  let(:optional_service) do
    build(:service, service_id: main_service.id, professional: professional)
  end
  let(:invalid) { Service.new }

  describe 'instances an empty customer' do
    subject { Service.new }
    it { is_expected.to be_a_new Service }
  end

  describe 'with valid attributes' do
    subject { service }
    it { is_expected.to be_valid }
  end

  describe 'with optional service' do
    before do
      service.service_id = main_service.id
      service.save!
    end

    it 'should returns the service id in the array' do
      expect(main_service.optional_service_ids).to eq [service.id]
    end

    it 'should remove the main and the children services' do
      expect { main_service.destroy }.to change(Service, :count).by(-2)
    end
  end

  describe 'with invalid attributes' do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe 'valitations' do
    it "should verify the 'presence'" do
      invalid.save
      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[professional title duration price]
      expect(invalid.errors.messages.count).to eq 4
      expect(invalid.errors.messages[:professional]).to eq ["é obrigatório(a)"]
      expect(invalid.errors.messages[:title]).to eq ["não pode ficar em branco", "é muito curto (mínimo: 3 caracteres)"]
      expect(invalid.errors.messages[:duration]).to eq ["não pode ficar em branco"]
      expect(invalid.errors.messages[:price]).to eq ["não pode ficar em branco"]
    end

    it "should verify the 'is_comissioned'" do
      service.is_comissioned = nil
      service.save
      expect(service.errors.empty?).to be false
      expect(service.errors.attribute_names).to eq %i[is_comissioned]
      expect(service.errors.messages.count).to eq 1
      expect(service.errors.messages[:is_comissioned]).to eq ["não está incluído na lista"]
    end

    describe "should verify the 'length'" do
      it 'should verify the mimimum' do
        service.title = 'ab'
        service.save
        expect(service.errors.messages.count).to be 1
        expect(service.errors.attribute_names).to eq %i[title]
        expect(service.errors.messages[:title]).to eq ["é muito curto (mínimo: 3 caracteres)"]
      end

      it "should verify the 'maximum'" do
        service.title = 'abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde'
        service.save
        expect(service.errors.attribute_names).to eq %i[title]
        expect(service.errors.messages.count).to be 1
        expect(service.errors.messages[:title]).to eq ["é muito longo (máximo: 50 caracteres)"]
      end
    end
  end
end
