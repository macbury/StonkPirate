module Holdings
  class Performance < Service
    use Assets::MarketValue, as: :calculate_market_value

    def initialize(holding, from: nil, to: Time.zone.now)
      @holding = holding
      @from = from&.to_date || holding.open_date
      @to = to.to_date
    end

    def call
      return 0.to_money unless holding.open_date <= from
      return 0.to_money if holding.close_date && holding.close_date <= to

      from_price = from == holding.open_date ? holding.open_price : price_at(from)
      to_price = to == holding.close_date ? holding.close_price : price_at(to)

      from_market_value = holding.amount * from_price
      to_market_value = holding.amount * to_price

      change = to_market_value - from_market_value
      change_percent = (change / from_market_value)

      HoldingPerformance.new(
        to_market_value,
        change,
        change_percent,
        to
      )
    end

    private

    attr_reader :holding, :from, :to

    def price_at(at)
      Rails.cache.fetch([holding, at]) do
        calculate_market_value(currency: holding.asset.currency, ticker: holding.asset.ticker, at: at)
      end
    end
  end
end
