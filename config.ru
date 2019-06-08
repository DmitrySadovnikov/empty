require './config/environment'

if ActiveRecord::MigrationContext.new('db/migrate').needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

run App
