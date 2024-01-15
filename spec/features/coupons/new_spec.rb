require "rails_helper"

describe "Merchant Coupon New" do
  before :each do
    @merchant1 = Merchant.create!(name: "Merchant 1")
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

    it "should be able to fill in a form and create a new coupon" do
      visit new_merchant_coupon_path(@merchant1)
    
      fill_in "Name", with: "20 percent"
      fill_in "Coupon code", with: "20poff"
      fill_in "Discount amount", with: "20"
      page.select "Percent"
      click_button "Submit"

      expect(current_path).to eq(merchant_coupons_path(@merchant1))

      within("#coupons") do
        expect(page).to have_content("20 percent off")
      end
    end
  end
end
