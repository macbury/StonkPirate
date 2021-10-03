
module Resolvers
  class AllAssets < Base
    include SearchObject.module(:graphql)

    scope do
      Asset.order(:name).distinct
    end

    type [Types::AssetType], null: false

    option(:observed, type: Boolean, required: false) { |scope, value| scope.where(observed: observed) }
    option(:status, type: Types::AssetStatusEnum, required: false) { |scope, value| scope.where(status: value) }
  end
end
