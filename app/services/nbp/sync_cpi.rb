module Nbp
  class SyncCpi < ReadChartService
    def endpoint
      'https://www.nbp.pl/statystyka/wskazniki/WS/mak_1_1.aspx?callback=dat'
    end

    def repo
      @repo ||= Stats::Cpi.new
    end
  end
end