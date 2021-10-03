module Holdings
  # Sell current holding. This service will create up to two holdings.
  # Input holding will be archived with current values. If number of shares to sell is below amount of shares in current holding, then copy this holding into two new holdings.
  # First one should be still open and have number of shares decreased. Second one should be closed with close date and close price and amount of shares passed into service.
  class Sell < TransactionService
    use Exchanges::Money, as: :exchange_money
    use Assets::MarketValue, as: :calculate_market_value

    def initialize(holding:, amount:, close_date: nil, close_price: nil, close_commission: nil)
      @holding = holding
      @asset = holding.asset
      @amount = amount
      @close_date = close_date || Time.zone.now
      @close_price = close_price
      @close_commission = close_commission
    end

    def call
      sold_holding = build_holding(
        state: :sell,
        amount: amount,
        close_date: close_date,
        close_price: possible_close_price,
        close_commission: commission,
        input: holding
      )

      buy_holding = build_holding(
        state: :buy,
        amount: sell_amount,
        open_commission: 0.to_money(asset.currency) # last sold position should include commission
      )

      sold_holding.save!
      if buy_holding.amount.positive?
        buy_holding.input = holding
        buy_holding.save!
      end

      holding.archived!

      buy_holding.persisted? ? [buy_holding, sold_holding] : [sold_holding]
    end

    private

    attr_reader :holding, :amount, :close_date, :close_price, :close_commission, :asset

    def sell_amount
      holding.amount - amount
    end

    def commission
      exchange_money(close_commission, to: asset.currency, at: close_date)
    end

    def build_holding(attrs)
      Holding.new(holding.attributes.except('id', 'updated_at', 'created_at', 'input_id', 'state').merge(attrs))
    end

    def possible_close_price
      close_price ? exchange_money(close_price, to: asset.currency, at: close_date) : calculate_market_value(currency: asset.currency, ticker: asset.ticker, at: close_date)
    end
  end
end