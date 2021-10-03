module Assets
  # Download information from https://www.nbp.pl/
  class SyncNbpWorker < Worker
    sidekiq_options retry: false

    use Nbp::SyncCpi, as: :sync_cpi
    use Nbp::SyncInterestRates, as: :sync_interest_rates
    use Nbp::SyncM3MoneySupply, as: :sync_s3_money_supply

    def perform
      sync_cpi
      sync_interest_rates
      sync_s3_money_supply
    end
  end
end