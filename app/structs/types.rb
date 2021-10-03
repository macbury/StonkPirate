module Types
  include Dry.Types()

  TickerFromString = Ticker.constructor do |value|
    Ticker.parse(value)
  end
end
