module Assets
  class SyncWorker < Worker
    use TradingView::FetchAssetData, as: :fetch_asset_data

    def perform(asset_id)
      asset = Asset.not_archived.find(asset_id)

      fetch_asset_data(asset: asset)
    end
  end
end