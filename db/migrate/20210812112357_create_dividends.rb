class CreateDividends < ActiveRecord::Migration[7.0]
  def change
    create_table :dividends do |t|
      t.monetize :amount
      t.belongs_to :asset, null: false, foreign_key: true, type: :string
      t.date :date

      t.timestamps
    end
  end
end
