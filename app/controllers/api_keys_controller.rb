class Application < Sinatra::Base
  # POST /api/v1/api-keys - Create a new API key
  post '/api/v1/api-keys' do
    data = parse_json_body

    api_key = ApiKey.new(name: data['name'])

    if api_key.save
      json_response({
        id: api_key.id,
        name: api_key.name,
        key: api_key.key,
        created_at: api_key.created_at
      }, 201)
    else
      json_response({ errors: api_key.errors.full_messages }, 422)
    end
  end

  # GET /api/v1/api-keys - List all API keys
  get '/api/v1/api-keys' do
    api_keys = ApiKey.all
    json_response({
      api_keys: api_keys.map do |key|
        {
          id: key.id,
          name: key.name,
          key_preview: "#{key.key[0..10]}...#{key.key[-4..-1]}",
          revoked: !key.active?,
          revoked_at: key.revoked_at,
          last_used_at: key.last_used_at,
          created_at: key.created_at
        }
      end
    })
  end

  # DELETE /api/v1/api-keys/:id - Revoke an API key
  delete '/api/v1/api-keys/:id' do
    api_key = ApiKey.find_by(id: params[:id])

    if api_key.nil?
      json_response({ error: 'API key not found' }, 404)
    else
      api_key.revoke!
      json_response({ message: 'API key revoked successfully' })
    end
  end
end
