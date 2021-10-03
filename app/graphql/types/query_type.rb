module Types
  class QueryType < Types::BaseObject
    field :search, resolver: Resolvers::SearchTicker
    field :asset, resolver: Resolvers::FindAsset
    field :assets, resolver: Resolvers::AllAssets
    field :holdings, resolver: Resolvers::AllHoldings
    field :holding, resolver: Resolvers::FindHolding
    field :categories, [CategoryType], null: false
    field :dividends, [DividendType], null: false
    field :default_currency, CurrencyType, null: false

    def categories
      Category.order(:name)
    end

    def default_currency
      ::Money.default_currency
    end

    def dividends
      Dividend.order('date DESC')
    end
  end
end
