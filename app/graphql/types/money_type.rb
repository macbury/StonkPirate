
module Types
  class MoneyType < Types::BaseObject
    use Exchanges::Money, as: :exchange_money

    field :cents, Integer, null: false
    field :currency, CurrencyType, null: false
    field :formatted, String, null: true
    field :amount, Float, null: true

    field :exchange, MoneyType, null: false do
      argument :currency, String, required: false
      argument :at, GraphQL::Types::ISO8601DateTime, required: false
    end

    def formatted
      object.format
    end

    def amount
      object.to_s.to_f
    end

    def exchange(currency: ::Money.default_currency, at: nil)
      exchange_money(object, to: currency, at: context[:at] || at)
    end
  end
end