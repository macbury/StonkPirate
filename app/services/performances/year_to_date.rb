module Performances
  class YearToDate < Service
    use Holdings::Performance, as: :calculate_performance

    def initialize(to: Time.zone.now, from: nil)
      @to = to.to_date
      @from = from || @to.at_beginning_of_year.to_date
      @today = @to.beginning_of_month
    end

    def call
      Holding.buy.where('close_date IS NULL OR close_date <= :to', to: to).find_each do |holding|
        months.each do |month|
          date = month == today ? to : month
          dates[month] += calculate_performance(holding, to: date).exchange_to_main_currency.market_value
        end
      end
      dates
    end

    private

    attr_reader :from, :to, :today

    def dates
      @dates ||= months.each_with_object({}) { |month, object| object[month] = 0.to_money }
    end

    def months
      @months ||= (from.to_date..to.to_date).map(&:beginning_of_month).uniq
    end
  end
end
