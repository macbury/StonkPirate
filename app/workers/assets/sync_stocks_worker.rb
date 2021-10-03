module Assets
  class SyncStocksWorker < Worker
    def perform(observed)
      asset_ids = Asset.assets_for_processing.where(observed: observed).pluck(:id)
      asset_ids.shuffle.each { |asset_id| SyncWorker.perform_async(asset_id) }
    end

    private

    def sync_assets
      Asset.currency.not_archived.pluck(:id)
    end
  end
end