Sidekiq.configure_server do |config|
    config.on(:startup) do
      Sidekiq::Scheduler.load_schedule!
    end
  end