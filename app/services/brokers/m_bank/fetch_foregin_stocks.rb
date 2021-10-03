module Brokers
  module MBank
    # https://www.mbank.pl/pdf/ind/inwestycje/lista-akcji-zagranicznych.pdf
    class FetchForeginStocks < Service
      use DownloadPdf, as: :download_pdf
      URL = 'https://www.mbank.pl/pdf/ind/inwestycje/lista-akcji-zagranicznych.pdf'.freeze #TODO: Move this to initializer and fetch on demand
      EXCHANGE_NAME = /(.+)\((.+)\)/i.freeze

      def call
        lines = download_pdf(URL)

        lines[25..-1].map do |line|
          row = split(line)
          next unless row.size == 8

          PendingInstrument.new(
            name: row[2]&.strip,
            symbol: row[4]&.strip,
            isin: row[6]&.strip
          )
        end.compact
      end

      private
      
      def split(line)
        line.split(/ {3}/i).map(&:strip).reject(&:empty?)
      end
    end
  end
end