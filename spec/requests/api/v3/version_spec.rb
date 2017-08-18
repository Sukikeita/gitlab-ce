require 'spec_helper'

describe API::V3::V3::Version do
  describe 'GET /version' do
    context 'when unauthenticated' do
      it 'returns authentication error' do
        get v3_api('/version')

        expect(response).to have_gitlab_http_status(401)
      end
    end

    context 'when authenticated' do
      let(:user) { create(:user) }

      it 'returns the version information' do
        get v3_api('/version', user)

        expect(response).to have_gitlab_http_status(200)
        expect(json_response['version']).to eq(Gitlab::VERSION)
        expect(json_response['revision']).to eq(Gitlab::REVISION)
      end
    end
  end
end
