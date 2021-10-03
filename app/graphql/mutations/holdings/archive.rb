module Mutations
  module Holdings
    class Archive < BaseMutation
      null true

      argument :id, ID, required: true

      field :errors, [String], null: false
      field :holding, Types::HoldingType, null: true

      def resolve(id:)
        holding = Holding.find(id)
        holding.archived!

        {
          errors: [],
          holding: holding,
        }
      end
    end
  end
end