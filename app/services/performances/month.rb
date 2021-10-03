module Performances
  class Month < Service
    def initialize(to: Time.zone.now, from: nil)
      @to = to.to_date
      @from = from || @to.at_beginning_of_year.to_date
      @today = @to.beginning_of_month

      @tickers = Tickers.new
    end

    def call
      # get holdings assets
      # get assets values at the end of month
    end

    private

    attr_reader :tickers, :from, :to
  end
end