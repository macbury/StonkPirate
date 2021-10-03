module Resolvers
  class FindHolding < Base
    type Types::HoldingType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Holding.find(id)
    end
  end
end