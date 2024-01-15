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

  enum discount_type: [:dollars, :percent]
  enum status: [:active, :inactive]
end
