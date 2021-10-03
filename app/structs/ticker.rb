class Ticker < Dry::Struct
  attribute :symbol, Types::String
  attribute :exchange, Types::String.optional

  def to_s
    id
  end

  def id
    [exchange, symbol].compact.join(':').upcase
  end
  
  def profile_id
    [exchange, symbol].compact.join('-').upcase
  end

  def url
    "https://www.tradingview.com/symbols/#{profile_id}/"
  end

  def self.parse(value)
    return value if value.is_a?(Ticker)

    parts = value&.split(':') || []
    if parts.size == 2
      exchange, symbol = parts
      
      new(exchange: exchange, symbol: symbol)
    elsif parts.size == 1
      new(symbol: parts[0], exchange: nil)
    else
      nil
    end
  end

  def self.currency(from:, to:)
    Ticker.new(symbol: [from, to].join.upcase, exchange: nil)
  end
end