module Types
  class SearchResultType < Types::BaseObject
    field :ticker, TickerType, null: false
    field :description, String, null: true
    field :country, String, null: true
    field :type, String, null: true
  end
end
