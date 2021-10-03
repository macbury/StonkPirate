module Exchanges
  class Create < Service
    use Assets::Create, as: :create_asset

    def initialize(currency:)
      @currency = currency.upcase
      @main_currency = ::Money.default_currency.to_s
    end

    def call
      return unless currency

      @currency = 'GBP' if currency == 'GBX'
      return if currency == main_currency

      from_default_to_target = Ticker.currency(from: main_currency, to: currency)
      from_target_to_default = Ticker.currency(to: main_currency, from: currency)

      create_asset(ticker: from_default_to_target)
      create_asset(ticker: from_target_to_default)
    end

    private

    attr_reader :currency, :main_currency
  end
end