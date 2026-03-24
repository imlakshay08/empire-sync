require 'rails_helper'

RSpec.describe SyncListingsJob, type: :job do
  it "calls ListingSyncService.sync" do
    allow(ListingSyncService).to receive(:sync)
    SyncListingsJob.perform_now
    expect(ListingSyncService).to have_received(:sync)
  end
end
