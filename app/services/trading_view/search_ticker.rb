module TradingView
  class SearchTicker < Service
    def initialize(ticker:)
      @ticker = ticker
    end

    def call
      results.map do |result|
        build_search_result(result)
      end
    end

    attr_reader :ticker

    def endpoint
      "https://symbol-search.tradingview.com/symbol_search/?text=#{ticker}"
    end

    def results
      Rails.cache.fetch(['ticker', ticker], expires: 2.days) do
        sleep 0.1
        client.get(endpoint).body
      end
    end

    def client
      @client ||= Faraday.new do |f|
        f.response :json
        f.request :retry
      end
    end

    def build_search_result(result)
      type = result['type']
      SearchResult.new(
        description: result['description'],
        type: type,
        country: result['country'],
        ticker: {
          symbol: result['symbol'],
          exchange: type == 'forex' ? nil : result['exchange']
        }
      )
    end
  end
end