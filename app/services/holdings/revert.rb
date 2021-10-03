module Holdings
  class Revert < TransactionService
    def initialize(sold_holding:)
      @sold_holding = sold_holding
    end

    def call
      input = sold_holding.input
      input.outputs.destroy_all
      input.buy!
      input
    end

    private

    attr_reader :sold_holding
  end
end