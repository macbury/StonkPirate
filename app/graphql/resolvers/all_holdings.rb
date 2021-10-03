
module Resolvers
  class AllHoldings < Base
    include SearchObject.module(:graphql)

    scope do
      Holding.order(:created_at)
    end

    type [Types::HoldingType], null: false

    option(:state, type: Types::HoldingStateEnum, required: false) { |scope, value| scope.where(state: value) }
    option(:ticker, type: ID, required: false) { |scope, value| scope.where(asset_id: value) }
  end
end
