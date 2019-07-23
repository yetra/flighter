RSpec.describe 'Users API create', type: :request do
  include TestHelpers::JsonResponse
  include TestHelpers::JsonParams

  describe 'POST /api/users(.:format)' do
    context 'when params are valid' do
      it 'creates a user' do
        expect do
          post '/api/users',
               params: user_params.to_json,
               headers: api_headers
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include('first_name' => user_params[:user][:first_name],
                                             'last_name' => user_params[:user][:last_name],
                                             'email' => user_params[:user][:email])
      end

      it 'registers created user with provided password' do
        post '/api/users',
             params: user_params(email: 'a2@b.com').to_json,
             headers: api_headers

        user = User.find(json_body['user']['id'])
        expect(user.authenticate(user_params[:user][:password])).to eq(user)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/users',
               params: user_params(first_name: '', email: '', password: '').to_json,
               headers: api_headers
        end.not_to change(User, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('first_name', 'email', 'password')
      end
    end
  end
end
