require 'csv'

module Holdings
  class GenerateCsv < Service
    def initialize
      @today = Time.zone.now
    end

    def call
      CSV.generate do |csv|
        csv << data_type
        csv << group
        csv << default
        csv << header

        Holding.where(state: [:buy, :sell]).find_each do |holding|
          csv << row(holding)
        end
      end
    end

    private

    attr_reader :today

    def data_type
      ['#datatype', 'string', 'long', 'dateTime:RFC3339', 'dateTime:RFC3339', 'dateTime:RFC3339', 'string' , 'double']
    end
    
    def group
      ['#group'] + ([false] * (header.count - 1))
    end

    def default
      ['#default'] + ([nil] * (header.count - 1))
    end

    def header
      [nil, 'result', 'table', '_time', '_stop', '_start', '_measurement', '_value']
    end

    def row(holding)
      amount = holding.buy? ? holding.amount : -holding.amount
      [nil, nil, 0, time(holding.open_date), time(holding.close_date || today), time(holding.open_date), holding.asset_id, amount]
    end

    def time(date)
      date.to_datetime.rfc3339
    end
  end
end