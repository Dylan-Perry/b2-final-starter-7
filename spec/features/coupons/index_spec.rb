require "rails_helper"
require "helper_methods"

RSpec.describe "coupons index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Donkus Goods")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @coupon1 = create(:coupon, merchant_id: @merchant1.id, discount_amount: 10, discount_type: 0)
    @coupon2 = create(:coupon, merchant_id: @merchant1.id, discount_amount: 5, discount_type: 1, status: 1)
    @coupon3_alt_merchant = create(:coupon, merchant_id: @merchant2.id, discount_amount: 20)

    visit merchant_coupons_path(@merchant1)
  end

  describe "User Story 1: Merchant Coupons Index" do
    # As a merchant
    # When I visit my merchant dashboard page
    # I see a link to view all of my coupons
    # When I click this link
    # I'm taken to my coupons index page
    # Where I see all of my coupon names including their amount off
    # And each coupon's name is also a link to its show page.

    it "shows the merchant name" do
      expect(page).to have_content(@merchant1.name)
    end
  
    it "shows the names of all the merchant's coupons" do
      expect(page).to have_content(@coupon1.name)
      expect(page).to have_content(@coupon2.name)
      expect(page).to_not have_content(@coupon3_alt_merchant.name)
    end
  
    it "shows the discount amount and discount type of all the merchant's coupons" do
      expect(page).to have_content("Discount: #{@coupon1.discount_amount} #{@coupon1.discount_type} off")
      expect(page).to have_content("Discount: #{@coupon2.discount_amount} #{@coupon2.discount_type} off")
      expect(page).to_not have_content("Discount: #{@coupon3_alt_merchant.discount_amount} #{@coupon3_alt_merchant.discount_type} off")
    end
  
    it "shows links to each coupon's show page on the coupon's name" do
      expect(page).to have_link("#{@coupon1.name}")
      expect(page).to have_link("#{@coupon2.name}")
      expect(page).to_not have_link("#{@coupon3_alt_merchant.name}")
  
      click_link("#{@coupon1.name}", match: :first)
      expect(current_path).to eq(merchant_coupon_path(merchant_id: @merchant1.id, id: @coupon1.id))
    end
  end

  describe "User Story 2: Merchant Coupon Create" do
    # As a merchant
    # When I visit my coupon index page
    # I see a link to create a new coupon.
    # When I click that link
    # I am taken to a new page where I see a form to add a new coupon.
    # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
    # And click the Submit button
    # I'm taken back to the coupon index page
    # And I can see my new coupon listed.

    # *** Sad Paths to consider:

    # This Merchant already has 5 active coupons
    # Coupon code entered is NOT unique**
    
    it "has a link to create a new coupon" do
      click_link "Create New Coupon"
      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
    end
  end

  describe "User Story 6: Merchant Coupon Index Sorted" do
    # As a merchant
    # When I visit my coupon index page
    # I can see that my coupons are separated between active and inactive coupons.

    it "has a section for inactive coupons" do
      load_test_data_6

      visit merchant_coupons_path(@merchant1)

      within("#inactive") do
        expect(page).to have_content(@coupon1.name)
        expect(page).to_not have_content(@coupon2.name)
        expect(page).to_not have_content(@coupon3.name)
      end

      visit merchant_coupons_path(@merchant2)

      within("#inactive") do
        expect(page).to have_content(@coupon4.name)
        expect(page).to have_content(@coupon5.name)
        expect(page).to_not have_content(@coupon6.name)
      end
    end
  
    it "has a section for active coupons" do
      load_test_data_6

      visit merchant_coupons_path(@merchant1)

      within("#active") do
        expect(page).to_not have_content(@coupon1.name)
        expect(page).to have_content(@coupon2.name)
        expect(page).to have_content(@coupon3.name)
      end

      visit merchant_coupons_path(@merchant2)

      within("#active") do
      expect(page).to_not have_content(@coupon4.name)
      expect(page).to_not have_content(@coupon5.name)
      expect(page).to have_content(@coupon6.name)
      end
    end

    it "can make a button to activate/deactivate coupons" do
      within("#coupon-#{@coupon1.id}") do
        click_button "Activate"
  
        coupon1 = Coupon.find(@coupon1.id)
        expect(coupon1.status).to eq("active")
      end

      visit merchant_coupons_path(@merchant1)

      within("#coupon-#{@coupon2.id}") do
        click_button "Deactivate"
  
        coupon2 = Coupon.find(@coupon2.id)
        expect(coupon2.status).to eq("inactive")
      end
    end
  end
end
