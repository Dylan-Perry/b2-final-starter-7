FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
  end

  factory :invoice do
    status {[0,1,2].sample}
    association :customer
    association :coupon
  end

  factory :merchant do
    name {Faker::Space.galaxy}
    status { 0 }
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    association :merchant
    status { 0 }
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    credit_card_expiration_date {Faker::Business.credit_card_expiry_date}
    association :invoice
  end

  factory :invoice_item do
    quantity { [1,2,3,4,5].sample }
    unit_price { item.unit_price }
    status { [0,1,2].sample }
    association :invoice
    association :item
  end

  factory :coupon do
    name {Faker::Hobby.activity}
    coupon_code {Faker::Alphanumeric.alphanumeric(number: 6, min_alpha: 3, min_numeric: 3)}
    discount_amount {Faker::Number.number(digits: 2)}
    discount_type {[0,1].sample}
    association :merchant
  end
end
