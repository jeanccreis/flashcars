class Application < Sinatra::Base
  # GET /api/v1/cars
  get '/api/v1/cars' do
    # TODO: Implement list cars logic
    json_response({
      cars: [
        { id: 1, model: 'Example Car', brand: 'Example Brand', year: 2024, color: 'Red' },
        { id: 2, model: 'Another Car', brand: 'Another Brand', year: 2023, color: 'Blue' },
        { id: 3, model: 'Third Car', brand: 'Third Brand', year: 2025, color: 'Green' }
      ]
    })
  end

  # GET /api/v1/cars/:id
  get '/api/v1/cars/:id' do
    # TODO: Implement get car by id logic
    id = params[:id]
    json_response({
      id: id,
      model: 'Example Car',
      brand: 'Example Brand',
      year: 2024,
      color: 'Red'
    })
  end

end
