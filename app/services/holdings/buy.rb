module Holdings
  class Buy < Service
    use Exchanges::Money, as: :exchange_money
    use Assets::MarketValue, as: :calculate_market_value

    def initialize(asset:, date:, amount:, price: nil, commission: nil)
      @asset = asset
      @date = date
      @amount = amount
      @price = price
      @commission = commission || 0.to_money
    end

    def call
      asset.holdings.create!(
        state: :buy,
        open_date: date,
        amount: amount,
        open_price: possible_price,
        open_commission: open_commission,
        close_commission: 0.to_money(asset.currency)
      )
    end

    private

    attr_reader :asset, :date, :amount, :price, :commission

    def possible_price
      price > 0 ? exchange_money(price, to: asset.currency, at: date) : calculate_market_value(currency: asset.currency, ticker: asset.ticker, at: date)
    end

    def open_commission
      exchange_money(commission, to: asset.currency, at: date)
    end
  end
end