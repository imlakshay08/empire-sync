class SyncListingsJob < ApplicationJob
  queue_as :default

  def perform
    ListingSyncService.sync
    # Do something later
  end
end
