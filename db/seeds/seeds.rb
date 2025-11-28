puts "Starting to seed database..."

Car.destroy_all

cars_data = [
  { model: 'Civic', brand: 'Honda', year: 2024, color: 'Prata' },
  { model: 'Corolla', brand: 'Toyota', year: 2023, color: 'Branco' },
  { model: 'Golf', brand: 'Volkswagen', year: 2025, color: 'Preto' },
  { model: 'Fusion', brand: 'Ford', year: 2022, color: 'Azul' },
  { model: 'Onix', brand: 'Chevrolet', year: 2024, color: 'Vermelho' },
  { model: 'HB20', brand: 'Hyundai', year: 2023, color: 'Verde' },
  { model: 'Kicks', brand: 'Nissan', year: 2024, color: 'Branco' },
  { model: 'Compass', brand: 'Jeep', year: 2025, color: 'Preto' },
  { model: 'T-Cross', brand: 'Volkswagen', year: 2023, color: 'Cinza' },
  { model: 'Renegade', brand: 'Jeep', year: 2024, color: 'Laranja' }
]

cars_data.each do |car_attrs|
  car = Car.create!(car_attrs)
  puts "Created car: #{car.brand} #{car.model} (#{car.year}) - #{car.color}"
end

puts "Seeding completed! Total cars: #{Car.count}"
