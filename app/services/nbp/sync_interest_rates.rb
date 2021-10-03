module Nbp
  class SyncInterestRates < ReadChartService
    def endpoint
      'https://www.nbp.pl/statystyka/wskazniki/WS/sp_1_2.aspx?callback=dat'
    end

    def repo
      @repo ||= Stats::InterestRate.new
    end
  end
end