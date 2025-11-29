class Rack::Attack
  ### Configure Cache ###
  # Use in-memory cache for development/simple deployments
  # For production with multiple servers, configure Redis:
  # Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle API requests by API key ###

  # Extract API key from request
  def self.extract_api_key(req)
    auth_header = req.env['HTTP_AUTHORIZATION']
    if auth_header&.start_with?('Bearer ')
      return auth_header.sub('Bearer ', '')
    end
    req.env['HTTP_X_API_KEY']
  end

  # Custom throttle for Free plan (by user, not by API key)
  throttle('api_requests_free', limit: 100, period: 1.hour) do |req|
    if req.path.start_with?('/api/v1/')
      api_key_string = extract_api_key(req)
      next unless api_key_string

      api_key = ApiKey.active.find_by(key: api_key_string)
      next unless api_key

      user = api_key.user
      next unless user && user.plan == 'free'

      req.env['rack.attack.user'] = user
      user.id
    end
  end

  # Custom throttle for Basic plan (by user, not by API key)
  throttle('api_requests_basic', limit: 1000, period: 1.hour) do |req|
    if req.path.start_with?('/api/v1/')
      api_key_string = extract_api_key(req)
      next unless api_key_string

      api_key = ApiKey.active.find_by(key: api_key_string)
      next unless api_key

      user = api_key.user
      next unless user && user.plan == 'basic'

      req.env['rack.attack.user'] = user
      user.id
    end
  end

  # Custom throttle for Pro plan (by user, not by API key)
  throttle('api_requests_pro', limit: 10000, period: 1.hour) do |req|
    if req.path.start_with?('/api/v1/')
      api_key_string = extract_api_key(req)
      next unless api_key_string

      api_key = ApiKey.active.find_by(key: api_key_string)
      next unless api_key

      user = api_key.user
      next unless user && user.plan == 'pro'

      req.env['rack.attack.user'] = user
      user.id
    end
  end

  ### Custom response for throttled requests ###
  self.throttled_responder = lambda do |req|
    match_data = req.env['rack.attack.match_data']
    now = Time.now

    # Calculate retry after in seconds
    retry_after = (match_data[:period] - (now.to_i % match_data[:period])).to_s

    headers = {
      'Content-Type' => 'application/json',
      'X-RateLimit-Limit' => req.env['rack.attack.match_limit'].to_s,
      'X-RateLimit-Remaining' => '0',
      'X-RateLimit-Reset' => (now + retry_after.to_i).to_i.to_s,
      'Retry-After' => retry_after
    }

    body = {
      error: 'Rate limit exceeded',
      message: "You have exceeded your rate limit. Please try again in #{retry_after} seconds.",
      retry_after: retry_after.to_i
    }.to_json

    [429, headers, [body]]
  end

  ### Add rate limit headers to all API responses ###
  self.throttled_response_retry_after_header = true
end
