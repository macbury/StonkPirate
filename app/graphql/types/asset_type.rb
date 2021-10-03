module Types
  class AssetType < Types::BaseObject
    use Assets::MarketValue, as: :calculate_market_value

    field :id, ID, null: false
    field :ticker, TickerType, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :country, CountryType, null: true
    field :logo_url, String, null: true
    field :currency, CurrencyType, null: true
    field :currencies, [CurrencyType], null: true
    field :kind, AssetKindEnum, null: false
    field :status, AssetStatusEnum, null: false
    field :market_value, MoneyType, null: false do
      argument :at, GraphQL::Types::ISO8601DateTime, required: false
    end
    field :history, AssetHistoryType, null: true, description: 'Flux CSV with historic data' do
      argument :currency, String, required: false
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :daily_change, MoneyType, null: false
    field :daily_change_percent, Float, null: false, description: '1.0 == 100%'
    field :year_change_percent, Float, null: false, description: '1.0 == 100%'

    def country
      object.country ? Country[object.country] : nil
    end

    def currency
      object.currency.present? ? Money::Currency.new(object.currency) : ::Money.default_currency
    end

    def currencies
      [currency, ::Money.default_currency].uniq
    end

    def history(currency: ::Money.default_currency)
      {
        asset: object,
        currency: ::Money::Currency.new(currency)
      }
    end

    def market_value(at: nil)
      Rails.cache.fetch([object, 'market_value', at&.to_date].compact) do
        calculate_market_value(currency: object.currency, ticker: object.ticker, at: at)
      end
    end

    def daily_change
      market_value - market_value(at: 1.day.ago.end_of_day)
    end

    def daily_change_percent
      (daily_change / market_value)
    end

    def year_change_percent
      year_change = market_value - market_value(at: 1.year.ago.end_of_day)
      (year_change / market_value)
    end
  end
end
