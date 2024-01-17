class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_by_merchant_with_coupon
    invoice_items
      .joins(item: :merchant)
      .where(item: {merchant: coupon.merchant})
      .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def discounted_revenue
    if coupon.discount_type == "dollars"
      total_revenue.to_f - coupon.discount_amount.to_f
    elsif coupon.discount_type == "percent"
      total_revenue.to_f - (total_revenue_by_merchant_with_coupon.to_f * (coupon.discount_amount.to_f / 100))
    end
  end
end
