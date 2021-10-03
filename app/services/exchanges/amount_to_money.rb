module Exchanges
  class AmountToMoney < Service
    PENSE = :gbx

    def initialize(amount:, currency: nil)
      @amount = amount
      @currency = ::Money::Currency.new(currency || ::Money.default_currency)
      @pense = @currency.id == PENSE
      @currency = ::Money::Currency.new('GBP') if pense
    end

    def call
      cents = pense ? amount : amount * currency.subunit_to_unit
      ::Money.new(cents, currency)
    end

    private

    attr_reader :amount, :currency, :pense
  end
end