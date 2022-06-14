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
          it 'sends Você já está logado(a). flash message' do
            expect(flash[:notice]).to eq "Você já está logado(a)."
          end
        end
      end
    end
  end

  describe 'GET /failure' do
    subject { response }
    before { get '/auth/failure' }

    it { is_expected.to have_http_status(:redirect) }
    it { is_expected.to redirect_to login_path }
    it 'sends Email ou Senha está incorreto. flash message' do
      expect(flash[:alert]).to eq "Email ou Senha está incorreto."
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
      it { is_expected.to redirect_to login_path }
      it 'sends Deslogado(a). flash message' do
        expect(flash[:notice]).to eq "Deslogado(a)."
      end
    end
  end
end
