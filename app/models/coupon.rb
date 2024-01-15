class Coupon < ApplicationRecord  
  validates_presence_of :name,
                        :coupon_code,
                        :discount_amount,
                        :discount_type,
                        :status,
                        :merchant_id

  validates_uniqueness_of :coupon_code

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  enum discount_type: [:dollars, :percent]
  enum status: [:active, :inactive]

  def times_used
    invoices
      .joins(:transactions)
      .where("transactions.result = 1")
      .count
  end

  def pending_invoices?
    self.invoice_items.where(status: 0).exists?
  end
end
