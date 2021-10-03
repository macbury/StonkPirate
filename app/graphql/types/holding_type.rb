module Types
  class HoldingType < Types::BaseObject
    use Assets::MarketValue, as: :calculate_market_value

    field :id, ID, null: false
    field :amount, Float, null: false
    field :asset, AssetType, null: false
    field :state, Types::HoldingStateEnum, null: false

    field :open_date, GraphQL::Types::ISO8601Date, null: true
    field :close_date, GraphQL::Types::ISO8601Date, null: false
    field :open_price, Types::MoneyType, null: true
    field :close_price, Types::MoneyType, null: false
    field :open_commission, Types::MoneyType, null: true
    field :close_commission, Types::MoneyType, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :open_value, MoneyType, null: false
    field :market_value, MoneyType, null: false do
      argument :at, GraphQL::Types::ISO8601DateTime, required: false
    end
    field :net_gain, MoneyType, null: false do
      argument :at, GraphQL::Types::ISO8601DateTime, required: false
    end
    field :net_gain_percent, Float, null: false, description: '1.0 == 100%' do
      argument :at, GraphQL::Types::ISO8601DateTime, required: false
    end
    field :daily_change, MoneyType, null: false
    field :daily_change_percent, Float, null: false, description: '1.0 == 100%'

    def open_value
      context[:at] = object.open_date
      object.amount * object.open_price
    end

    def market_value(at: sample_date)
      context[:at] = at
      Rails.cache.fetch([object, 'market_value', at.to_date]) do
        object.amount * calculate_market_value(currency: object.asset.currency, ticker: object.asset.ticker, at: at)
      end
    end

    def net_gain(at: sample_date)
      context[:at] = at
      market_value(at: at) - open_value - object.open_commission - object.close_commission
    end

    def net_gain_percent(at: sample_date)
      net_gain(at: at) / open_value
    end

    def daily_change
      market_value - market_value(at: sample_prev_date.end_of_day)
    end

    def daily_change_percent
      (daily_change / open_value)
    end

    def sample_date
      object.close_date || Time.zone.now.end_of_day
    end

    def sample_prev_date
      sample_date - 1.day
    end
  end
end
