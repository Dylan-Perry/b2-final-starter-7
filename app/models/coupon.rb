class Coupon < ApplicationRecord  
  validates_presence_of :name,
                        :coupon_code,
                        :discount_amount,
                        :discount_type,
                        :status,
                        :merchant_id

  validates_uniqueness_of :coupon_code, scope: :merchant_id

  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum discount_type: [:dollars, :percent]
  enum status: [:active, :inactive]
end
