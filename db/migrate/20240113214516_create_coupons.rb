class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :coupon_code
      t.integer :discount_amount
      t.integer :discount_type
      t.references :merchant, foreign_key: true
      t.references :invoices, foreign_key: true

      t.timestamps
    end

    add_index :coupons, :coupon_code, unique: true
  end
end
