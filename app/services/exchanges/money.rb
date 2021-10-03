module Exchanges
  class Money < Service
    def initialize(money, at: nil, to: nil)
      @money = money
      @at = at || Time.zone.now
      @to = ::Money::Currency.new(to || ::Money.default_currency)
    end

    def call
      return money if money.currency == to

      Rails.cache.fetch(cache_key, expires: 30.minutes) do
        exchange_amount = tickers.latest(currency_ticker, stop: at).values.first&.records&.first&.value || 0.0

        (money * exchange_amount).with_currency(to)
      end
    end

    private

    attr_reader :money, :to, :at

    def tickers
      @tickers ||= Tickers.new
    end

    def currency_ticker
      [@money.currency.iso_code, to.iso_code].join
    end

    def cache_key
      ['exchange', money, to, at.today? ? nil : at].compact
    end
  end
end