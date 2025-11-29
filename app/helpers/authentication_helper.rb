module AuthenticationHelper
  def authenticate_with_api_key!
    api_key = extract_api_key

    unless api_key
      halt 401, json_response({ error: 'API key required' }, 401)
    end

    @current_api_key = ApiKey.active.find_by(key: api_key)

    unless @current_api_key
      halt 401, json_response({ error: 'Invalid or revoked API key' }, 401)
    end

    # Update last used timestamp
    @current_api_key.update_column(:last_used_at, Time.now)
  end

  def current_api_key
    @current_api_key
  end

  private

  def extract_api_key
    # Check Authorization header first (Bearer token)
    # In Rack, Authorization header can be in different places
    auth_header = request.env['HTTP_AUTHORIZATION'] || env['HTTP_AUTHORIZATION']
    if auth_header&.start_with?('Bearer ')
      return auth_header.sub('Bearer ', '')
    end

    # Fallback to X-API-Key header
    request.env['HTTP_X_API_KEY'] || env['HTTP_X_API_KEY']
  end
end
