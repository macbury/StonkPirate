module Brokers
  class MatchInstrumentToTradingView < Service
    use TradingView::SearchTicker, as: :search_ticker
    use ::Assets::Create, as: :create_asset

    EXCHANGE_MAPPING = {
      'LN' => 'LSE',
      'GR' => 'XETR',
      'US' => 'NASDAQ'
    }

    def initialize(pending_instruments)
      @pending_instruments = pending_instruments
    end

    def call
      @pending_instruments.each_with_object({}) do |pending_instrument, result|
        match = search_ticker(ticker: pending_instrument.ticker).find { |search_result| match_result?(pending_instrument, search_result) }

        if match
          result[pending_instrument] = match
          info "Matched: #{pending_instrument.name} (#{pending_instrument.symbol}) with #{match.ticker}"
          create_asset(ticker: match.ticker)
        else
          info "Could not match: #{pending_instrument.name} #{pending_instrument.symbol}"
        end
      end
    end

    private

    attr_reader :pending_instruments

    def match_result?(pending_instrument, search_result)
      type = search_result.type.to_sym

      return unless type == :etf || type == :stock
      return unless pending_instrument.exchange

      EXCHANGE_MAPPING.fetch(pending_instrument.exchange) == search_result.ticker.exchange
    end
  end
end