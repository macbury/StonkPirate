module Types
  class DividendType < Types::BaseObject
    field :id, ID, null: false
    field :asset, AssetType, null: false
    field :amount, MoneyType, null: false
    field :date, GraphQL::Types::ISO8601Date, null: false
  end
end