class SearchResult < Dry::Struct
  attribute :ticker, Ticker

  attribute :description, Types::String
  attribute :country, Types::String.optional
  attribute :type, Types::String
end