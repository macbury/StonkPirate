
module Resolvers
  class SearchTicker < Base
    use TradingView::SearchTicker, as: :search
    type [Types::SearchResultType], null: false

    argument :ticker, String, required: true

    def resolve(ticker:)
      search(ticker: ticker)
    end
  end
end
