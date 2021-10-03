class Dividend < ApplicationRecord
  belongs_to :asset

  monetize :amount

  validates :amount, :date, presence: true
end
