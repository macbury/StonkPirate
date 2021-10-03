module Mutations
  module Holdings
    class Buy < BaseMutation
      use ::Holdings::Buy, as: :buy
      null true

      argument :ticker, ID, required: true
      argument :date, GraphQL::Types::ISO8601Date, required: true
      argument :amount, Float, required: true
      argument :price, Types::MoneyArgument, required: false
      argument :commission, Types::MoneyArgument, required: false

      field :errors, [String], null: false
      field :holding, Types::HoldingType, null: true

      def resolve(ticker:, **kwargs)
        asset = Asset.find(ticker)

        {
          holding: buy(asset: asset, **kwargs),
          errors: []
        }
      end
    end
  end
end