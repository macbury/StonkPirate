module TradingView
  class SymbolTypeToAssetKind < Service
    def initialize(type)
      @type = type.to_sym
    end

    def call
      case type
      when :dr
        :stock
      when :fund
        :etf
      when :forex
        :currency
      else
        type
      end
    end

    private

    attr_reader :type
  end
end