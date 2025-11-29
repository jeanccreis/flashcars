puts "Starting to seed database..."

Car.destroy_all
ApiKey.destroy_all

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

puts "Cars seeding completed! Total cars: #{Car.count}"

# Create Users with different plans
users_data = [
  { name: 'João Silva', email: 'joao@example.com', plan: 'free' },
  { name: 'Maria Santos', email: 'maria@example.com', plan: 'basic' },
  { name: 'Pedro Costa', email: 'pedro@example.com', plan: 'pro' },
  { name: 'Ana Lima', email: 'ana@example.com', plan: 'free' }
]

users_data.each do |user_attrs|
  user = User.create!(user_attrs)
  puts "Created User: #{user.name} (#{user.email}) - Plan: #{user.plan}"
end

puts "Users seeding completed! Total users: #{User.count}"

# Create API Keys for each user
User.all.each do |user|
  # Create 2 API keys per user to demonstrate that multiple keys share the same rate limit
  2.times do |i|
    api_key = user.api_keys.create!(name: "#{user.name} - Key #{i + 1}")
    puts "Created API Key for #{user.name}: #{api_key.key}"
  end
end

puts "API Keys seeding completed! Total API keys: #{ApiKey.count}"
puts "\nSeeding completed successfully!"
