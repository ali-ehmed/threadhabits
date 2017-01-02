admin = AdminService.new.call
puts "Creating Admin User -> " << admin.username

@main_categories = [
  "High-end and Luxury",
  "Basic",
  "Hype"
]

@main_categories.each do |category|
  Category.find_or_create_by!(name: category) do |category|
    category.slug = category.name.parameterize
  end
end
puts "Creating Main Categories"

@product_types = [
  ["Tops", [
      "XXS / EU 40",
      "XS / EU 42 / 0",
      "S / EU 44-46 / 1",
      "M / EU 48-50 / 2",
      "L / EU 52-54 / 3",
      "XL / EU 56 /4",
      "XXL / EU 58 / 5"
    ], "Multiple"
  ],
  ["Bottoms", [
      "26 / EU 42",
      "27",
      "28 / EU 44",
      "29",
      "30 / EU 46",
      "31",
      "32 / EU 48",
      "33",
      "34 / EU 50",
      "35",
      "36 / EU 52",
      "37",
      "38 / EU 54",
      "39",
      "40 / EU 56",
      "41",
      "42 / EU 58",
      "43",
      "44 / EU 60"
    ], "Multiple"
  ],
  ["Shoes", [
      "US 6 / EU 39",
      "US 6.5 / EU 39",
      "US 7 / EU 40",
      "US 7.5 / EU 40-41",
      "US 8 / EU 41 ",
      "US 8.5 / EU 41-42",
      "US 9 / EU 42",
      "US 9.5 / EU 42-43",
      "US 10 / EU 43",
      "US 10.5 / EU 43-44",
      "US 11 / EU 44",
      "US 11.5 / EU 44-45",
      "US 12 / EU 45",
      "US 12.5 / EU 45-46",
      "US 13 / EU 46",
      "US 13.5 / 46-47",
      "US 14 / EU 47",
      "US 14.5 / EU 47-48",
      "US 15 / EU 48"
    ], "Multiple"
  ],
  ["Accessories", [
    "26",
    "28",
    "30",
    "32",
    "34",
    "36",
    "38",
    "40",
    "42",
    "44",
    "46"
    ], "Single"
  ]
]

@product_types.each do |product_type|
  product = ProductType.find_or_create_by!(name: product_type[0])
  product_type[1].each do |size|
    product.sizes.find_or_create_by!(name: size, selection: product_type[2])
  end
end

puts "Creating Product Type & Sizes"
