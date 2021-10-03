module Assets
  class SyncMbankWorker < Worker
    sidekiq_options retry: false

    use Brokers::MatchInstrumentToTradingView, as: :match_to_trading_view
    #use Brokers::MBank::FetchForeginStocks, as: :list_of_stocks 
    use Brokers::MBank::FetchEtfs, as: :list_of_etfs

    def perform
      #match_to_trading_view(list_of_stocks)
      match_to_trading_view(list_of_etfs)
    end
  end
end