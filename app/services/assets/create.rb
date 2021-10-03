module Assets
  class Create < Service
    def initialize(ticker:)
      @ticker = Ticker.parse(ticker)
    end

    def call
      asset = Asset.find_or_initialize_by(id: ticker.id)

      unless asset.persisted?
        asset.assign_attributes(symbol: ticker.symbol, exchange: ticker.exchange)
        asset.save!
      end

      asset.initializing! unless asset.ready?
      Assets::SyncWorker.perform_async(asset.id)
      asset
    end

    private

    attr_reader :ticker
  end
end