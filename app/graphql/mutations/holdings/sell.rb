module Mutations
  module Holdings
    class Sell < BaseMutation
      use ::Holdings::Sell, as: :sell
      null true

      argument :id, ID, required: true
      argument :close_date, GraphQL::Types::ISO8601Date, required: true
      argument :amount, Float, required: true
      argument :close_price, Types::MoneyArgument, required: false
      argument :close_commission, Types::MoneyArgument, required: false

      field :errors, [String], null: false
      field :holdings, [Types::HoldingType], null: true

      def resolve(id:, **kwargs)
        holding = Holding.buy.find(id)

        {
          errors: [],
          holdings: sell(holding: holding, **kwargs),
        }
      end
    end
  end
end