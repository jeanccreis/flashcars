module RateLimitHelper
  def add_rate_limit_headers
    return unless @current_api_key

    user = @current_api_key.user
    return unless user

    # Get rate limit info from user
    limit = user.rate_limit
    period = user.rate_limit_period.to_i
    plan = user.plan

    # Calculate the time window
    now = Time.now.to_i
    window_start = now - (now % period)

    # Determine throttle name based on plan
    throttle_name = "api_requests_#{plan}"

    # Get count from Rack::Attack cache (using user_id, not api_key.id)
    cache_key = "#{throttle_name}:#{user.id}:count"
    data = Rack::Attack.cache.store.read(cache_key)
    count = data.is_a?(Integer) ? data : 0

    # Add headers
    headers['X-RateLimit-Limit'] = limit.to_s
    headers['X-RateLimit-Remaining'] = [limit - count, 0].max.to_s
    headers['X-RateLimit-Reset'] = (window_start + period).to_s
    headers['X-RateLimit-Plan'] = plan
    headers['X-RateLimit-User'] = user.email
  end
end
