class HoldingPerformance < Struct.new(:market_value, :change, :change_percent, :at)
  extend Usable
  use Exchanges::Money, as: :exchange_money

  def exchange_to_main_currency
    HoldingPerformance.new(
      exchange_money(market_value, at: at),
      exchange_money(change, at: at),
      change_percent,
      at
    )
  end
end