module Types
  class AssetHistoryType < Types::BaseObject
    field :timestamps, [Integer], null: false
    field :values, [Float], null: false
    field :currency, CurrencyType, null: false

    def timestamps
      points&.records&.map { |row| Time.zone.parse(row.time).to_i } || []
    end

    def values
      points&.records&.map(&:value) || []
    end

    private

    def tickers
      @tickers ||= Tickers.new
    end

    def asset
      object[:asset]
    end

    def currency
      object[:currency]
    end

    def points
      @points ||= Rails.cache.fetch([asset, currency, 'exchange_points']) do
        if currency == asset.currency
          tickers.values(asset.ticker)
        elsif currency == ::Money.default_currency
          tickers.exchange_values(asset.ticker, ticker_currency: asset.currency)
        else
          nil
        end
      end
    end
  end
end