require 'spec_helper'

describe API::V3::V3::Variables do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:project) { create(:project, creator_id: user.id) }
  let!(:master) { create(:project_member, :master, user: user, project: project) }
  let!(:developer) { create(:project_member, :developer, user: user2, project: project) }
  let!(:variable) { create(:ci_variable, project: project) }

  describe 'GET /projects/:id/variables' do
    context 'authorized user with proper permissions' do
      it 'returns project variables' do
        get v3_api("/projects/#{project.id}/variables", user)

        expect(response).to have_http_status(200)
        expect(json_response).to be_a(Array)
      end
    end

    context 'authorized user with invalid permissions' do
      it 'does not return project variables' do
        get v3_api("/projects/#{project.id}/variables", user2)

        expect(response).to have_http_status(403)
      end
    end

    context 'unauthorized user' do
      it 'does not return project variables' do
        get v3_api("/projects/#{project.id}/variables")

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /projects/:id/variables/:key' do
    context 'authorized user with proper permissions' do
      it 'returns project variable details' do
        get v3_api("/projects/#{project.id}/variables/#{variable.key}", user)

        expect(response).to have_http_status(200)
        expect(json_response['value']).to eq(variable.value)
        expect(json_response['protected']).to eq(variable.protected?)
      end

      it 'responds with 404 Not Found if requesting non-existing variable' do
        get v3_api("/projects/#{project.id}/variables/non_existing_variable", user)

        expect(response).to have_http_status(404)
      end
    end

    context 'authorized user with invalid permissions' do
      it 'does not return project variable details' do
        get v3_api("/projects/#{project.id}/variables/#{variable.key}", user2)

        expect(response).to have_http_status(403)
      end
    end

    context 'unauthorized user' do
      it 'does not return project variable details' do
        get v3_api("/projects/#{project.id}/variables/#{variable.key}")

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /projects/:id/variables' do
    context 'authorized user with proper permissions' do
      it 'creates variable' do
        expect do
          post v3_api("/projects/#{project.id}/variables", user), key: 'TEST_VARIABLE_2', value: 'VALUE_2', protected: true
        end.to change {project.variables.count}.by(1)

        expect(response).to have_http_status(201)
        expect(json_response['key']).to eq('TEST_VARIABLE_2')
        expect(json_response['value']).to eq('VALUE_2')
        expect(json_response['protected']).to be_truthy
      end

      it 'creates variable with optional attributes' do
        expect do
          post v3_api("/projects/#{project.id}/variables", user), key: 'TEST_VARIABLE_2', value: 'VALUE_2'
        end.to change {project.variables.count}.by(1)

        expect(response).to have_http_status(201)
        expect(json_response['key']).to eq('TEST_VARIABLE_2')
        expect(json_response['value']).to eq('VALUE_2')
        expect(json_response['protected']).to be_falsey
      end

      it 'does not allow to duplicate variable key' do
        expect do
          post v3_api("/projects/#{project.id}/variables", user), key: variable.key, value: 'VALUE_2'
        end.to change {project.variables.count}.by(0)

        expect(response).to have_http_status(400)
      end
    end

    context 'authorized user with invalid permissions' do
      it 'does not create variable' do
        post v3_api("/projects/#{project.id}/variables", user2)

        expect(response).to have_http_status(403)
      end
    end

    context 'unauthorized user' do
      it 'does not create variable' do
        post v3_api("/projects/#{project.id}/variables")

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /projects/:id/variables/:key' do
    context 'authorized user with proper permissions' do
      it 'updates variable data' do
        initial_variable = project.variables.first
        value_before = initial_variable.value

        put v3_api("/projects/#{project.id}/variables/#{variable.key}", user), value: 'VALUE_1_UP', protected: true

        updated_variable = project.variables.first

        expect(response).to have_http_status(200)
        expect(value_before).to eq(variable.value)
        expect(updated_variable.value).to eq('VALUE_1_UP')
        expect(updated_variable).to be_protected
      end

      it 'responds with 404 Not Found if requesting non-existing variable' do
        put v3_api("/projects/#{project.id}/variables/non_existing_variable", user)

        expect(response).to have_http_status(404)
      end
    end

    context 'authorized user with invalid permissions' do
      it 'does not update variable' do
        put v3_api("/projects/#{project.id}/variables/#{variable.key}", user2)

        expect(response).to have_http_status(403)
      end
    end

    context 'unauthorized user' do
      it 'does not update variable' do
        put v3_api("/projects/#{project.id}/variables/#{variable.key}")

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /projects/:id/variables/:key' do
    context 'authorized user with proper permissions' do
      it 'deletes variable' do
        expect do
          delete v3_api("/projects/#{project.id}/variables/#{variable.key}", user)

          expect(response).to have_http_status(204)
        end.to change {project.variables.count}.by(-1)
      end

      it 'responds with 404 Not Found if requesting non-existing variable' do
        delete v3_api("/projects/#{project.id}/variables/non_existing_variable", user)

        expect(response).to have_http_status(404)
      end
    end

    context 'authorized user with invalid permissions' do
      it 'does not delete variable' do
        delete v3_api("/projects/#{project.id}/variables/#{variable.key}", user2)

        expect(response).to have_http_status(403)
      end
    end

    context 'unauthorized user' do
      it 'does not delete variable' do
        delete v3_api("/projects/#{project.id}/variables/#{variable.key}")

        expect(response).to have_http_status(401)
      end
    end
  end
end
