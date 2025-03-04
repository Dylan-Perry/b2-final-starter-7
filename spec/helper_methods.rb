def load_test_data_us_3
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Donkus Goods")

    @coupon1 = create(:coupon, coupon_code: "BOGO14", merchant_id: @merchant1.id)
    @coupon2 = create(:coupon, coupon_code: "freb14", merchant_id: @merchant1.id) 
    @coupon3 = create(:coupon, coupon_code: "hehelol", merchant_id: @merchant2.id)

    @invoice1 = create(:invoice, coupon_id: @coupon1.id)
    @invoice2 = create(:invoice, coupon_id: @coupon1.id)
    @invoice3 = create(:invoice, coupon_id: @coupon2.id)
    @invoice4 = create(:invoice, coupon_id: @coupon2.id)
    @invoice5 = create(:invoice, coupon_id: @coupon3.id)

    @transaction1 = create(:transaction, invoice_id: @invoice1.id, result: 1)
    @transaction2 = create(:transaction, invoice_id: @invoice1.id, result: 1)
    @transaction3 = create(:transaction, invoice_id: @invoice1.id, result: 0) # Sad path: should not count, transaction status = 0
    @transaction4 = create(:transaction, invoice_id: @invoice2.id, result: 1)
    @transaction5 = create(:transaction, invoice_id: @invoice2.id, result: 1) 
    @transaction6 = create(:transaction, invoice_id: @invoice3.id, result: 0) # Sad path: should not count, transaction status = 0
    @transaction7 = create(:transaction, invoice_id: @invoice4.id, result: 1)
    @transaction8 = create(:transaction, invoice_id: @invoice5.id, result: 0) # Sad path: should not count, transaction status = 0

    expect(@coupon1.times_used).to eq 4
    expect(@coupon2.times_used).to eq 1
    expect(@coupon3.times_used).to eq 0
end

def load_test_data_us_4
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = create(:coupon, coupon_code: "BOGO14", merchant_id: @merchant1.id, status: 1)
    @coupon2 = create(:coupon, coupon_code: "flarpo", merchant_id: @merchant1.id, status: 1)

    @invoice1 = create(:invoice, coupon_id: @coupon1.id)
    @invoice2 = create(:invoice, coupon_id: @coupon1.id)
    @invoice3 = create(:invoice, coupon_id: @coupon2.id)
    @invoice4 = create(:invoice, coupon_id: @coupon2.id)

    @item = create(:item, merchant_id: @merchant1.id)

    @invoice_item1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice1.id, status: 1)
    @invoice_item2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice1.id, status: 1)
    @invoice_item3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice2.id, status: 1)
    @invoice_item4 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice2.id, status: 1)
    @invoice_item5 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice3.id, status: 1)
    @invoice_item6 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice3.id, status: 1)
    @invoice_item7 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice4.id, status: 0) # Sad path: pending status prevents @coupon2 from deactivating
    @invoice_item8 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice4.id, status: 1)
end

def load_test_data_6
    @coupon1 = create(:coupon, merchant_id: @merchant1.id)
    @coupon2 = create(:coupon, merchant_id: @merchant1.id, status: 1)
    @coupon3 = create(:coupon, merchant_id: @merchant1.id, status: 1)

    @coupon4 = create(:coupon, merchant_id: @merchant2.id)
    @coupon5 = create(:coupon, merchant_id: @merchant2.id)
    @coupon6 = create(:coupon, merchant_id: @merchant2.id, status: 1)
end

def load_test_data_8
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
    @invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 9, unit_price: 10, status: 2)
    @invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_4.id, quantity: 6, unit_price: 10, status: 1)
end