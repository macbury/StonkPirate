module Assets
  class SyncPkoWorker < Worker
    sidekiq_options retry: false

    use Pkobp::SyncPositions, as: :sync

    def perform
      sync
    end
  end
end