require "rails_helper"

RSpec.describe Customer, type: :model do
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:customer) { create(:customer, :with_avatar, user_id: user.id) }
  let(:invalid) { Customer.new }

  describe "instances an empty customer" do
    subject { Customer.new }
    it { is_expected.to be_a_new Customer }
  end

  describe "with valid attributes" do
    subject { customer }
    it { is_expected.to be_valid }
  end

  describe "with invalid attributes" do
    subject { invalid }
    it { is_expected.to be_invalid }
  end

  describe "valitations" do
    it "should verify the 'presence'" do
      invalid.valid?

      expect(invalid.errors.empty?).to be false
      expect(invalid.errors.attribute_names).to eq %i[name]
      expect(invalid.errors.messages.count).to eq 1
      expect(invalid.errors.messages[:name]).to eq ["não pode ficar em branco"]
    end

    it "should verify the 'email format'" do
      customer.email = "john.doe"
      customer.valid?

      expect(customer.errors.attribute_names).to eq [:email]
      expect(customer.errors.messages[:email]).to eq ["não é válido"]
    end

    it "should verify the uniqueness" do
      invalid = build(:customer, :with_avatar, email: customer.email, document: customer.document, user_id: user.id)
      invalid.valid?

      expect(invalid.errors.empty?).to be_falsy
      expect(invalid.errors.attribute_names).to eq %i[email document]
      expect(invalid.errors.messages.count).to eq 2
      expect(invalid.errors.messages[:email]).to eq ["já está em uso"]
      expect(invalid.errors.messages[:document]).to eq ["já está em uso"]
    end

    describe "should verify the 'length'" do
      it "should verify the mimimum" do
        customer = build(:customer, :with_avatar, user_id: user.id, name: "ab", phone: "1234567", address: "123456789", document: "123456789")
        customer.valid?

        expect(customer.errors.messages.count).to be 4
        expect(customer.errors.attribute_names).to eq %i[name phone address document]
        expect(customer.errors.messages[:name]).to eq ["é muito curto (mínimo: 3 caracteres)"]
        expect(customer.errors.messages[:phone]).to eq ["é muito curto (mínimo: 8 caracteres)"]
        expect(customer.errors.messages[:address]).to eq ["é muito curto (mínimo: 10 caracteres)"]
        expect(customer.errors.messages[:document]).to eq ["é muito curto (mínimo: 10 caracteres)"]
      end

      it "should verify the 'maximum'" do
        customer =
          build(
            :customer,
            :with_avatar,
            user_id: user.id,
            name:
              "abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde",
            phone: "1234567890123456",
            address:
              "abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde
               abcde abcde abcde abcde abcde abcde abcde abcde abcde abcde",
            document: "123456789012345678"
          )
        customer.save
        expect(customer.errors.messages.count).to be 4
        expect(customer.errors.attribute_names).to eq %i[name phone address document]
        expect(customer.errors.messages[:name]).to eq ["é muito longo (máximo: 100 caracteres)"]
        expect(customer.errors.messages[:phone]).to eq ["é muito longo (máximo: 15 caracteres)"]
        expect(customer.errors.messages[:address]).to eq ["é muito longo (máximo: 150 caracteres)"]
        expect(customer.errors.messages[:document]).to eq ["é muito longo (máximo: 16 caracteres)"]
      end
    end
  end
end
