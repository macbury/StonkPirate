module Assets
  class CreateCash < Service
    def call
      currency = ::Money.default_currency
      asset = Asset.cash.find_or_initialize_by(id: currency.iso_code)
      asset.update!(
        name: currency.name,
        currency: currency.iso_code,
        status: :ready,
        kind: :cash,
        exchange: nil, 
        symbol: currency.iso_code
      )

      asset
    end
  end
end