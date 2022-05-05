require 'rails_helper'

RSpec.describe QrcodeGenerator, type: :model do
  let(:qrcode_generate) { QrcodeGenerator.new(5) }
  let(:identity) { create(:identity) }
  let(:user) { create(:user, uid: identity.id) }
  let(:identification_key) { build(:identification_key, user: user) }
  let(:identification_key2) { build(:identification_key) }

  describe '#create_keys' do
    context 'invalid attributes :quantity' do
      it { expect { QrcodeGenerator.new }.to raise_error ArgumentError }
    end

    context 'valid attributes quantity: 5' do
      context 'when user_id exists' do
        before { identification_key.save! }

        it { expect { qrcode_generate.create_keys }.to change(IdentificationKey, :count).to(6) }
        it { expect(IdentificationKey.first).to eq identification_key }
      end

      context 'when user_id does not exists' do
        before { identification_key2.save! }

        it { expect { qrcode_generate.create_keys }.to change(IdentificationKey, :count).by(5) }
      end
    end
  end
end
