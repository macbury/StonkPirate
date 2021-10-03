module TradingView
  class PullData < BrowserService
    use Exchanges::AmountToMoney, as: :amount_to_money
    DELIMETER = /~m~\d+~m~/i
    ALL_RANGES = ['All', '5Y', '1Y', '1M', '5D']
    FOR_TODAY_RANGES = ['1D', '5D']

    def initialize(browser:, ticker:, ranges:)
      super(browser: browser)
      
      @ticker = ticker
      @ranges = ranges
    end

    def call
      info "Visiting: #{url}"
      browser.get(url)
      sleep 5
      
      info "Scroll into chart toolbar"
      scroll_into_view('chart-toolbar')

      ranges.each do |range|
        info "Selecting range: #{range}"
        range_buttons[range].click
        sleep 1
      end

      sleep 10

      info "Collecting points"
      points = received_data.flat_map do |data|
        next unless values = is_timeseries?(data)

        values
      end.compact

      {
        description: description,
        type: symbol_data.fetch(:type),
        points: points,
        name: symbol_data.fetch(:description),
        market: symbol_data.fetch(:exchange),
        country: symbol_data.fetch(:country), 
        currency: final_currency,
        ticker: ticker,
        value: value,
        pe: pe,
        logo_url: logo_url 
      }
    end

    private 

    attr_reader :market, :ticker, :ranges

    def symbol_data
      @symbol_data ||= browser.execute_script('return initData.symbolInfo').symbolize_keys
    end

    def range_buttons
      find_elements(css: 'div[data-name="date-ranges-tabs"] .apply-common-tooltip').each_with_object({}) do |button, r|
        r[button.text.strip] = button
      end
    end

    def description
      find_text(css: '.tv-widget-description__text', timeout: 1.second)
    end

    def logo_url
      if element_exists?(css: '.tv-category-header__icon.tv-circle-logo--large', timeout: 1.second)
        find_element(css: 'meta[name="twitter:image"]')[:content]
      else
        currency_icons = find_elements(css: '.tv-circle-logo-pair__logo.tv-circle-logo-pair__logo--large', timeout: 1.second) || []
        return currency_icons.last[:src].gsub('--big.svg', '--600.png') unless currency_icons.empty?
        nil
      end
    rescue Selenium::WebDriver::Error::TimeoutError
      nil
    end

    def pe
      find_elements(css: '.tv-fundamental-block .js-symbol-pe', timeout: 1.second).last&.text&.to_f
    rescue Selenium::WebDriver::Error::TimeoutError
      nil
    end

    def value
      find_text(css: '.tv-symbol-price-quote__value', timeout: 1.second)
    rescue Selenium::WebDriver::Error::TimeoutError
      nil
    end

    def currency
      @currency ||= symbol_data.fetch(:currency)
    end

    def final_currency
      amount_to_money(amount: 0, currency: currency).currency.iso_code
    end

    def url
      "https://www.tradingview.com/symbols/#{ticker.id}"
    end

    def received_data
      received_websocket_events.reverse.flat_map { |event| split_data(event.dig('params', 'response', 'payloadData')) }.compact
    end

    def split_data(payload_data)
      payload_data.split(DELIMETER).reject { |e| e.size < 10 }.map { |data| JSON.parse(data) }
    end

    def is_timeseries?(data)
      return unless data['m'] == 'timescale_update'
      
      timeseries(data)
    end

    # {
    #     "i": 48,
    #     "v": [
    #         1491202800, # date 2017-04-03 09:00:00 +0200
    #         4.63, # opening
    #         5.34, # highest price
    #         4.46, # lowest price
    #         5.17,# closing price?
    #         127042 # volumen
    #     ]
    # },
    #
    def timeseries(data)
      return unless data

      data.dig('p', 1, 'sds_1', 's')&.map do |d|
        v = d['v']

        if v[0].nil?
          next
        end
        
        {
          timestamp: Time.at(v[0]),
          opening: amount_to_money(amount: v[1], currency: currency).to_f,
          highest: amount_to_money(amount: v[2], currency: currency).to_f,
          lowest: amount_to_money(amount: v[3], currency: currency).to_f,
          value: amount_to_money(amount: v[4], currency: currency).to_f,
          volume: v[5]
        }
      end&.compact
    end
  end
end