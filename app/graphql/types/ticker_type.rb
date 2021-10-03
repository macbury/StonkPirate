module Types
  class TickerType < Types::BaseObject
    field :id, ID, null: false
    field :symbol, String, null: false
    field :exchange, String, null: true
    field :url, String, null: false
  end
end
