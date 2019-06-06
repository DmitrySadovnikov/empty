Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }, network_timeout: 5 }
end

Sidekiq::Cron::Job.load_from_hash(YAML.load_file('config/schedule.yml'))
