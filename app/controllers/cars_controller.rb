class Application < Sinatra::Base
  # GET /api/cars
  get '/api/cars' do
    # TODO: Implement list cars logic
    json_response({
      cars: [
        { id: 1, model: 'Example Car', brand: 'Example Brand', year: 2024 }
      ]
    })
  end

  # GET /api/cars/:id
  get '/api/cars/:id' do
    # TODO: Implement get car by id logic
    id = params[:id]
    json_response({
      id: id,
      model: 'Example Car',
      brand: 'Example Brand',
      year: 2024
    })
  end

  # POST /api/cars
  post '/api/cars' do
    # TODO: Implement create car logic
    request.body.rewind
    data = JSON.parse(request.body.read) rescue {}

    json_response({
      message: 'Car created',
      car: data
    }, 201)
  end

  # PUT /api/cars/:id
  put '/api/cars/:id' do
    # TODO: Implement update car logic
    id = params[:id]
    request.body.rewind
    data = JSON.parse(request.body.read) rescue {}

    json_response({
      message: 'Car updated',
      id: id,
      car: data
    })
  end

  # DELETE /api/cars/:id
  delete '/api/cars/:id' do
    # TODO: Implement delete car logic
    id = params[:id]
    json_response({
      message: 'Car deleted',
      id: id
    })
  end
end
