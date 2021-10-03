module Brokers
  module MBank
    class DownloadPdf < Service
      def initialize(url)
        @url = url
      end

      def call
        Rails.cache.fetch("brokers/mbank/#{url}", expires_in: 1.day) do
          content = Down.download(url)
          pdf = PDF::Reader.new(content)
          pdf.pages.flat_map { |page| page.text.split("\n") }.map(&:strip).reject(&:empty?)
        end
      end

      private

      attr_reader :url
    end
  end
end