require './config/environment'

namespace :db do
  desc 'Run migrations'
  task :migrate do
    puts 'Running migrations...'
    # Add migration logic here
  end

  desc 'Seed database'
  task :seed do
    puts 'Seeding database...'
    # Add seed logic here
  end

  desc 'Reset database'
  task :reset do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end

desc 'Start console'
task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end
