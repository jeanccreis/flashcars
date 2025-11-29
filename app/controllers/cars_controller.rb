class Application < Sinatra::Base
  # Authentication filter for /api/v1/cars routes (read-only API)
  before '/api/v1/cars*' do
    authenticate_with_api_key!
  end

  # Add rate limit headers to all API responses
  after '/api/v1/*' do
    add_rate_limit_headers
  end

  # GET /api/v1/cars - List all cars
  get '/api/v1/cars' do
    cars = Car.all
    json_response({
      cars: cars.map(&:to_hash),
      total: cars.count
    })
  end

  # GET /api/v1/cars/:id - Get a specific car
  get '/api/v1/cars/:id' do
    car = Car.find_by(id: params[:id])

    if car
      json_response(car.to_hash)
    else
      json_response({ error: 'Car not found' }, 404)
    end
  end

end
