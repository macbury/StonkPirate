class Asset < ApplicationRecord
  include LogoUploader::Attachment(:logo)

  enum status: {
    initializing: 'initializing',
    ready: 'ready',
    failed: 'failed',
    archived: 'archived'
  }

  enum kind: {
    unknown: 'unknown',
    currency: 'currency',
    etf: 'etf',
    stock: 'stock',
    crypto: 'crypto',
    bonds: 'bonds',
    cfd: 'cfd',
    cash: 'cash'
  }

  belongs_to :category, optional: true
  has_many :holdings, dependent: :destroy
  has_many :dividends, dependent: :destroy

  validates :symbol, presence: true, uniqueness: { scope: :exchange }

  scope :assets_for_processing, -> { not_archived.not_cash.not_currency.not_crypto.where.not(exchange: 'PKOBP') }
  scope :by_ticker, ->(ticker) { where(symbol: ticker.symbol, exchange: ticker.exchange) }

  def ticker
    Ticker.new(symbol: symbol, exchange: exchange)
  end

  def default_currency?
    currency == ::Money.default_currency
  end
end
