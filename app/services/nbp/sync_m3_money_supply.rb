module Nbp
  # Change in M3 money supply in percentages or aka Real Inflation
  class SyncM3MoneySupply < ReadChartService
    def endpoint
      'https://www.nbp.pl/statystyka/wskazniki/WS/mon_7_2.aspx?callback=dat'
    end

    def repo
      @repo ||= Stats::M3MoneySupply.new
    end
  end
end