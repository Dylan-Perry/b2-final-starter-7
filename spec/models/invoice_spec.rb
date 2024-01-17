require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to(:coupon).optional }
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe "discounted_revenue (User Story 7 and 8)" do
      # (User story 7) As a merchant
      # When I visit one of my merchant invoice show pages
      # I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
      # And I see the grand total revenue after the discount was applied
      # And I see the name and code of the coupon used as a link to that coupon's show page.

      it "subtracts dollar amount from total revenue" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @coupon_dollars = create(:coupon, discount_amount: 5, discount_type: 0)
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_dollars.id, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 6, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue).to eq(150)

        expect(@invoice_1.discounted_revenue).to eq(145)
      end

      it "subtracts percent only from coupon merchant's total revenue" do
        load_test_data_8

        expect(@invoice_1.total_revenue).to eq(300)

        expect(@invoice_1.discounted_revenue).to eq(292.5) # Indicates that 5% discount is only applied to @merchant1's items; otherwise would be 285
      end
    end

    describe "total_revenue_by_merchant_with_coupon (User Story 8)" do
      # (User story 8) As an admin
      # When I visit one of my admin invoice show pages
      # I see the name and code of the coupon that was used (if there was a coupon applied)
      # And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.

      # Alternate Paths to consider:
      # There may be invoices with items from more than 1 merchant. Coupons for a merchant only apply to items from that merchant.
      # When a coupon with a dollar-off value is used with an invoice with multiple merchants' items,
      # the dollar-off amount applies to the total amount even though there may be items present from another merchant.

      it "only applies coupon to items from the coupon's merchant" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Chair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "Wood Soap", description: "This washes your chair", unit_price: 10, merchant_id: @merchant2.id, status: 1)
        @item_4 = Item.create!(name: "Chair Clip", description: "This holds up your chair but in a clip", unit_price: 5, merchant_id: @merchant2.id)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @coupon_percent = create(:coupon, discount_amount: 5, discount_type: 1, merchant_id: @merchant1.id)

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_percent.id, created_at: "2012-03-27 14:54:09")

        @invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 6, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue_by_merchant_with_coupon).to eq(150)

        @invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 9, unit_price: 10, status: 2)
        @invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_4.id, quantity: 6, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue_by_merchant_with_coupon).to eq(150) # Invoice total revenue remains 150, despite adding items to invoice from @merchant2
      end
    end
  end
end
