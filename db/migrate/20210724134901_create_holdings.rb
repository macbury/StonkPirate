class CreateHoldings < ActiveRecord::Migration[7.0]
  def change
    create_table :holdings do |t|
      t.belongs_to :asset, null: false, foreign_key: true, type: :string
      t.float :amount, defualt: 0.0
      t.integer :input_id
      t.string :state
      t.date :open_date
      t.date :close_date
      t.monetize :open_price
      t.monetize :close_price
      t.monetize :open_commission
      t.monetize :close_commission

      t.timestamps
    end
  end
end
