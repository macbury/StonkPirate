module TradingView
  # Get asset infromation:
  # - name
  # - exchange
  # - currency
  # - current price
  # - PE
  # - highest price
  # - lowest price
  # - volume
  class FetchAssetData < Service
    use Exchanges::Create, as: :create_currency_exchange
    use PullData, as: :pull_data
    use SymbolTypeToAssetKind, as: :symbol_type_to_kind

    def initialize(asset:)
      @asset = asset
      @tickers = Tickers.new
    end

    def call
      @pull_for_today = tickers.count(asset.ticker).positive?

      update_asset!
      attach_logo!
      create_exchange!

      info "Pulling ranges: #{ranges}"

      write_points
      write_stats

      asset.touch
      asset.holdings.touch_all
      asset.ready!
      true
    rescue StandardError => e
      asset.failed!
      raise e
    end

    private

    attr_reader :asset, :pull_for_today, :tickers

    def write_points
      return if points_to_import.empty?

      info "Importing #{points_to_import.size} after #{current_points_timestamp}"

      tickers.write(asset.ticker.id, points_to_import, asset.currency, precision: pull_for_today ? 'm' : 'h')
    end

    def write_stats
      tickers.write_stats(asset.ticker.id, pe: data.fetch(:pe))
    end

    def data
      @data ||= pull_data(ranges: ranges, ticker: asset.ticker)
    end

    def points_to_import
      @points_to_import ||= data.fetch(:points).reject { |point| point[:timestamp].before?(current_points_timestamp) }
    end

    def ranges
      pull_for_today ? PullData::FOR_TODAY_RANGES : PullData::ALL_RANGES
    end

    def current_points_timestamp
      @current_points_timestamp ||= tickers.latest_timestamp(asset.ticker) || 100.years.ago
    end

    def attach_logo!
      return if asset.logo

      if data[:logo_url]
        info "Missing logo, found on page this one: #{data[:logo_url]}"
        asset.logo = LogoUploader.remote_url(data[:logo_url])
        asset.save!
      else
        info "Missing logo for: #{asset.id}"
      end
    end

    def update_asset!
      asset.update!(
        description: data.fetch(:description),
        name: data.fetch(:name),
        currency: data.fetch(:currency),
        country: data.fetch(:country),
        status: :ready,
        kind: symbol_type_to_kind(data.fetch(:type))
      )
    end

    def create_exchange!
      return if asset.currency?

      info "Asset is using currency: #{asset.currency}, creating exchange"
      create_currency_exchange(currency: asset.currency)
    end
  end
end