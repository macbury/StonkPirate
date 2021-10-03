module Resolvers
  class FindAsset < Base
    type Types::AssetType, null: true

    argument :ticker, String, required: true

    def resolve(ticker:)
      Asset.find(ticker)
    end
  end
end