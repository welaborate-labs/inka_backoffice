require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:http_request) { get '/auth/identity/callback', params: params }
  let(:uid) { '123123' }
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }
  let(:phone) { '1199997777' }
  let(:password_digest) { BCrypt::Password.create('123123') }
  let(:params) { { provider: :identity, uid: uid } }

  let(:identity) { build(:identity) }
  let(:user) { build(:user, uid: uid) }
  let!(:user_2) { create(:user, email: 'jane.doe@example.com') }

  describe 'GET /' do
    context 'when authenticated' do
      before do
        user.save
        allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
      end

      subject { response }
      before { get '/' }
      it { is_expected.to have_http_status(:success) }
    end

    context 'when does not authenticated' do
      subject { response }
      before { get '/' }
      it { is_expected.to have_http_status(:redirect) }
    end
  end

  describe 'GET /auth/:provider/callback' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :identity,
        {
          uid: uid,
          provider: 'identity',
          info: {
            name: user.email,
            email: user.email,
            phone: user.phone
          }
        }
      )
    end

    context 'user is not logged in' do
      context 'identity and user does not exist' do
        describe 'request' do
          it { expect { http_request }.to change { User.where(uid: uid).count }.by(1) }
        end

        describe 'response' do
          subject { response }
          before { http_request }
          it { is_expected.to have_http_status :redirect }
          it { is_expected.to redirect_to root_path }
          it 'sends Signed in! flash message' do
            expect(flash[:notice]).to eq 'Signed in!'
          end
        end
      end

      context 'user and identity exists' do
        before do
          identity.save!
          user.save!
        end

        describe 'request' do
          it { expect { http_request }.not_to change { User.count } }
        end

        describe 'response' do
          subject { response }
          before { http_request }

          it { is_expected.to have_http_status :redirect }
          it { is_expected.to redirect_to root_path }
          it 'sends Signed in! flash message' do
            expect(flash[:notice]).to eq 'Signed in!'
          end
        end
      end
    end

    context 'user is logged in' do
      before do
        identity.save!
        user.save!
        allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
      end

      context 'identity exists' do
        describe 'request' do
          it { expect { http_request }.not_to change { User.count } }
          it { expect { http_request }.not_to change { Identity.count } }
        end

        describe 'response' do
          subject { response }
          before { http_request }

          it { is_expected.to have_http_status :redirect }
          it { is_expected.to redirect_to root_path }
          it 'sends You are already logged in! flash message' do
            expect(flash[:notice]).to eq 'You are already logged in.'
          end
        end
      end
    end
  end

  describe 'GET /failure' do
    subject { response }
    before { get '/auth/failure' }

    it { is_expected.to have_http_status(:redirect) }
    it { is_expected.to redirect_to root_path }
    it 'sends Authentication failed, please try again. flash message' do
      expect(flash[:alert]).to eq 'Authentication failed, please try again.'
    end
  end

  describe 'GET /logout' do
    let(:http_request) { get '/logout' }

    before do
      identity.save!
      user.save!
      allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
    end

    describe 'response' do
      subject { response }
      before { http_request }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to root_path }
      it 'sends Signed out! flash message' do
        expect(flash[:notice]).to eq 'Signed out!'
      end
    end
  end
end
