module Brokers
  module MBank
    # https://www.mdm.pl/ds-server/41304?ticketSource=ui-pub sprawdz
    # https://www.mdm.pl/ui-pub/site/oferta_indywidualna/rynki_zagraniczne/lista_dostepnych_akcji_etf_i_adrgdr
    # Fetch current ETFs provided by mbank and return them as PendingEtf struct
    class FetchEtfs < Service
      use DownloadPdf, as: :download_pdf
      URL = 'https://www.mbank.pl/pdf/ind/inwestycje/lista-funduszy-etf.pdf'.freeze #TODO: Move this to initializer and fetch on demand
      EXCHANGE_NAME = /(.+)\((.+)\)/i.freeze

      def call
        lines = download_pdf(URL)

        lines.map do |line|
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