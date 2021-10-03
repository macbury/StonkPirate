module Assets
  class MarketValue < Service
    use Exchanges::AmountToMoney, as: :amount_to_money

    def initialize(currency:, ticker:, at:)
      @currency = currency
      @ticker = ticker
      @tickers = Tickers.new
      @at = at || Time.zone.now
    end

    def call
      value = tickers.latest(ticker, stop: at).values.first&.records&.first&.value
      amount_to_money(amount: value || 0, currency: currency)
    end

    private

    attr_reader :ticker, :currency, :tickers, :at
  end
end