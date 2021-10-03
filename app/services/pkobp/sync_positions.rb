module Pkobp
  class SyncPositions < BrowserService
    use PullData, as: :pull_data
    use Assets::CreateCash, as: :create_cash!

    FAVICON_IMAGE = 'https://www.obligacjeskarbowe.pl/static/_front/_treasurybonds/favicon/apple-touch-icon-144x144.png'

    DESCRIPTION = {
      /OTS/i => 'Obligacje 3-miesięczne OTS',
      /DOS/i => 'Obligacje 2-letnie DOS',
      /TOZ/i => 'Obligacje 3-letnie TOZ',
      /COI/i => 'Obligacje 4-letnie COI',
      /EDO/i => 'Obligacje 10-letnie EDO'
    }

    def call
      data = pull_data
      
      create_cash! #TODO: create position with :free_amount

      tickers = data[:bonds].map { |b| b[:ticker] }.uniq
      tickers.each do |ticker|
        create_bond(ticker)
      end
      # get unique tickers
      # for each ticker create asset with kind bond
    end

    private

    def match_name(name)
      DESCRIPTION.each do |regexp, description|
        return description if regexp.match(name)
      end
      name
    end
    

    def create_bond(ticker)
      asset = Asset.bonds.find_or_initialize_by(id: ticker.to_s)
      asset.update!(
        name: match_name(ticker.symbol),
        currency: 'PLN',
        country: 'PL',
        status: :ready,
        kind: :bonds,
        exchange: ticker.exchange, 
        symbol: ticker.symbol,
        logo: LogoUploader.remote_url(FAVICON_IMAGE)
      )
    end
  end
end