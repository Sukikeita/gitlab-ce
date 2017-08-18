require 'spec_helper'

describe API::V3::V3::Keys do
  let(:user)  { create(:user) }
  let(:admin) { create(:admin) }
  let(:key)   { create(:key, user: user) }
  let(:email) { create(:email, user: user) }

  describe 'GET /keys/:uid' do
    context 'when unauthenticated' do
      it 'returns authentication error' do
        get v3_api("/keys/#{key.id}")
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated' do
      it 'returns 404 for non-existing key' do
        get v3_api('/keys/999999', admin)
        expect(response).to have_http_status(404)
        expect(json_response['message']).to eq('404 Not found')
      end

      it 'returns single ssh key with user information' do
        user.keys << key
        user.save
        get v3_api("/keys/#{key.id}", admin)
        expect(response).to have_http_status(200)
        expect(json_response['title']).to eq(key.title)
        expect(json_response['user']['id']).to eq(user.id)
        expect(json_response['user']['username']).to eq(user.username)
      end

      it "does not include the user's `is_admin` flag" do
        get v3_api("/keys/#{key.id}", admin)

        expect(json_response['user']['is_admin']).to be_nil
      end
    end
  end
end
