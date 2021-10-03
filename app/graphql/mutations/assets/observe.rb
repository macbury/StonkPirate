module Mutations
  module Assets
    class Observe < BaseMutation
      use ::Assets::Create, as: :create
      description 'Start observing assets'
      null true

      argument :ticker, String, required: true

      field :errors, [String], null: false
      field :asset, Types::AssetType, null: true

      def resolve(ticker:)
        asset = create(ticker: ticker)
        asset.update!(observed: true)

        {
          asset: asset
        }
      end
    end
  end
end