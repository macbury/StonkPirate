class Category < ApplicationRecord
  has_many :assets, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
