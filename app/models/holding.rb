class Holding < ApplicationRecord
  belongs_to :asset
  belongs_to :input, class_name: 'Holding', inverse_of: :outputs, optional: true, foreign_key: 'input_id'
  has_many :outputs, inverse_of: :input, class_name: 'Holding', dependent: :destroy, foreign_key: 'input_id'

  enum state: {
    buy: 'buy',
    sell: 'sell',
    archived: 'archived'
  }

  monetize :close_commission_cents
  monetize :open_commission_cents
  monetize :open_price_cents
  monetize :close_price_cents

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_input_state

  def to_flux
    {
      'value' => amount,
      '_measurement' => asset_id,
      '_time' => open_date
    }
  end

  private

  def validate_input_state
    return unless input

    errors.add(:input, 'cant be sold again') if input.archived? && !archived?
    errors.add(:amount, 'to sell exceeds current amount') if amount > input.amount
  end
end
