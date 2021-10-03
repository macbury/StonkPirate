module Assets
  class SyncCurrencyWorker < Worker
    def perform
      asset_ids = Asset.not_archived.where(kind: [:currency, :crypto]).pluck(:id)
      asset_ids.shuffle.each { |asset_id| SyncWorker.perform_async(asset_id) }
    end
  end
end