class Application < Sinatra::Base
  # GET /api/v1/cars
  get '/api/v1/cars' do
    cars = Car.all
    json_response({
      cars: cars.map(&:to_hash)
    })
  end

  # GET /api/v1/cars/:id
  get '/api/v1/cars/:id' do
    car = Car.find_by(id: params[:id])

    if car
      json_response(car.to_hash)
    else
      json_response({ error: 'Car not found' }, 404)
    end
  end

  # POST /api/v1/cars
  post '/api/v1/cars' do
    data = JSON.parse(request.body.read)
    car = Car.new(data)

    if car.save
      json_response(car.to_hash, 201)
    else
      json_response({ errors: car.errors.full_messages }, 422)
    end
  end

  # PUT /api/v1/cars/:id
  put '/api/v1/cars/:id' do
    car = Car.find_by(id: params[:id])

    if car.nil?
      json_response({ error: 'Car not found' }, 404)
    else
      data = JSON.parse(request.body.read)
      if car.update(data)
        json_response(car.to_hash)
      else
        json_response({ errors: car.errors.full_messages }, 422)
      end
    end
  end

  # DELETE /api/v1/cars/:id
  delete '/api/v1/cars/:id' do
    car = Car.find_by(id: params[:id])

    if car.nil?
      json_response({ error: 'Car not found' }, 404)
    else
      car.destroy
      json_response({ message: 'Car deleted successfully' })
    end
  end

end
