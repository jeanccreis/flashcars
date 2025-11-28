require 'rake'
require 'active_record'
require 'yaml'

db_config = YAML.load_file('config/database.yml')
environment = ENV['RACK_ENV'] || 'development'

namespace :db do
  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(db_config[environment])
    puts "Database created successfully!"
  end

  desc 'Drop the database'
  task :drop do
    db_file = db_config[environment]['database']
    File.delete(db_file) if File.exist?(db_file)
    puts "Database dropped successfully!"
  end

  desc 'Run migrations'
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config[environment])
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    puts "Migrations completed!"
  end

  desc 'Rollback migration'
  task :rollback do
    ActiveRecord::Base.establish_connection(db_config[environment])
    ActiveRecord::MigrationContext.new('db/migrate').rollback
    puts "Rollback completed!"
  end

  desc 'Seed database'
  task :seed do
    require './config/environment'
    load 'db/seeds/seeds.rb'
    puts "Database seeded successfully!"
  end

  desc 'Reset database'
  task :reset do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Create migration (use: rake db:create_migration[migration_name])'
  task :create_migration, [:name] do |t, args|
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "db/migrate/#{timestamp}_#{args[:name]}.rb"
    File.write(filename, <<~MIGRATION)
      class #{args[:name].split('_').map(&:capitalize).join} < ActiveRecord::Migration[7.1]
        def change
        end
      end
    MIGRATION
    puts "Created migration: #{filename}"
  end
end

desc 'Start console'
task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end
