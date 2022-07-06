pass = BCrypt::Password.create("secret")

puts "creating identities..."
Identity.create!(
  [
    { name: "John Doe", email: "john.doe@example.com", phone: "1199998888", password_digest: pass },
    { name: "Jane Doe", email: "jane.doe@example.com", phone: "1177776666", password_digest: pass }
  ]
)
puts "#{Identity.count} identities created successfully!"

puts "creating users..."
User.create!(
  [
    {
      provider: "identity",
      uid: Identity.first.id,
      name: "John Doe",
      email: "john.doe@example.com",
      phone: "1199998888"
    },
    {
      provider: "identity",
      uid: Identity.last.id,
      name: "Jane Doe",
      email: "jane.doe@example.com",
      phone: "1177776666"
    }
  ]
)
puts "#{User.count} users created successfully!"

puts "creating customers..."
Customer.create!(
  [
    {
      name: "John",
      email: "john.customer@example.com",
      phone: "1111112222",
      address: "Some random Address",
      document: "12312312311",
      user_id: User.first.id,
      avatar: {
        io: File.open(File.join(Rails.root, "spec/fixtures/files/model.png")),
        filename: "model.png"
      }
    },
    {
      name: "Jane",
      email: "jane.customer@example.com",
      phone: "1111112222",
      address: "Some random Address",
      document: "12312312322",
      user_id: User.second.id,
      avatar: {
        io: File.open(File.join(Rails.root, "spec/fixtures/files/model.png")),
        filename: "model.png"
      }
    }
  ]
)
puts "#{Customer.count} customers created successfully!"

puts "creating Professionals..."
Professional.create!(
  [
    {
      name: "John",
      email: "john.professional@example.com",
      phone: "1111112222",
      address: "Some random Address",
      document: "12312312333",
      user_id: User.first.id,
      avatar: {
        io: File.open(File.join(Rails.root, "spec/fixtures/files/model.png")),
        filename: "model.png"
      }
    },
    {
      name: "Jane",
      email: "jane.professional@example.com",
      phone: "1122221111",
      address: "Some random Address",
      document: "12312312344",
      user_id: User.second.id,
      avatar: {
        io: File.open(File.join(Rails.root, "spec/fixtures/files/model.png")),
        filename: "model.png"
      }
    }
  ]
)
puts "#{Professional.count} professionals created successfully!"

puts "creating Services..."
Service.create!(
  [
    { title: "service_5min", duration: 5, price: 15, is_comissioned: false, professionals: [Professional.first] },
    { title: "service_15min", duration: 15, price: 25, is_comissioned: false, professionals: [Professional.first] },
    { title: "service_25min", duration: 25, price: 35, is_comissioned: false, professionals: [Professional.last] },
    { title: "service_30min_c", duration: 30, price: 45, is_comissioned: true, professionals: [Professional.last] }
  ]
)

Service.create!(
  [
    { title: "service_45min_o", duration: 45, price: 55, is_comissioned: false, service_id: Service.first.id, professionals: [Professional.first] },
    { title: "service_55min_o", duration: 55, price: 69, is_comissioned: false, service_id: Service.second.id, professionals: [Professional.first] }
  ]
)
puts "#{Service.count} services created successfully!"

puts "creating Schedules..."
7.times do |i|
  s = Schedule.new
  s.weekday = i
  s.starts_at = 7
  s.ends_at = 18
  s.interval_starts_at = 12
  s.interval_ends_at = 13
  s.professional_id = Professional.first.id
  s.save!
end
7.times do |i|
  s = Schedule.new
  s.weekday = i
  s.starts_at = 7
  s.ends_at = 18
  s.interval_starts_at = 12
  s.interval_ends_at = 13
  s.professional_id = Professional.second.id
  s.save!
end
puts "#{Schedule.count} schedules created successfully!"

year = DateTime.now.year
month = DateTime.now.month
day = DateTime.now.day
hour = 8
starts_at = DateTime.new(year, month, day, hour) + 5.day
ends_at = starts_at + 1.hour

puts "creating Service Bookings..."
Booking.create!(
  [
    {
      notes: "some note",
      status: 0,
      service_id: Service.second.id,
      professional_id: Service.third.professionals.first.id,
      customer_id: Customer.first.id,
      starts_at: starts_at - 1.day,
      ends_at: ends_at - 1.day
      professional_id: Professional.first.id,
    },
    {
      notes: "some note_2",
      status: 1,
      service_id: Service.second.id,
      professional_id: Service.third.professionals.first.id,
      customer_id: Customer.first.id,
      starts_at: starts_at - 2.days,
      ends_at: ends_at - 2.days
      professional_id: Professional.first.id,
    },
    {
      notes: "some note_3",
      status: 2,
      service_id: Service.third.id,
      professional_id: Service.third.professionals.first.id,
      customer_id: Customer.first.id,
      starts_at: starts_at - 3.days,
      ends_at: ends_at - 3.days
      professional_id: Professional.first.id,
    },
    {
      notes: "some note_3",
      status: 5,
      service_id: Service.third.id,
      professional_id: Service.third.professionals.first.id,
      customer_id: Customer.first.id,
      starts_at: starts_at - 4.days,
      ends_at: ends_at - 4.days
      professional_id: Professional.first.id,
    },
    {
      notes: "some note_4",
      status: 6,
      service_id: Service.second.id,
      professional_id: Service.third.professionals.first.id,
      customer_id: Customer.first.id,
      starts_at: starts_at - 5.days,
      ends_at: ends_at - 5.days
      professional_id: Professional.second.id,
    }
  ]
)
puts "#{Booking.count} service bookings created successfully!"

puts "creating Products..."
Product.create!(
  [
    { name: "some product name_1", sku: "SKU01", unit: "kg" },
    { name: "some product name_2", sku: "SKU02", unit: "mg" },
    { name: "some product name_3", sku: "SKU03", unit: "kg" },
    { name: "some product name_4", sku: "SKU04", unit: "ml" },
    { name: "some product name_5", sku: "SKU05", unit: "l" },
    { name: "some product name_6", sku: "PR06SK", unit: "unidade" }
  ]
)
puts "#{Product.count} products created successfully!"

puts "creating Stocks..."
Stock.create!(
  [
    { product_id: Product.first.id, quantity: 22, integralized_at: DateTime.now, type: "StockIncrement" },
    { product_id: Product.first.id, quantity: 2, integralized_at: DateTime.now, type: "StockDecrement" },
    { product_id: Product.second.id, quantity: 15, integralized_at: DateTime.now, type: "StockIncrement" },
    { product_id: Product.third.id, quantity: 10, integralized_at: DateTime.now, type: "StockIncrement" },
    { product_id: Product.fourth.id, quantity: 55, integralized_at: DateTime.now, type: "StockIncrement" },
    { product_id: Product.fifth.id, quantity: 120, integralized_at: DateTime.now, type: "StockIncrement" },
    { product_id: Product.fifth.id, quantity: 20, integralized_at: DateTime.now, type: "StockDecrement" },
    { product_id: Product.last.id, quantity: 20, integralized_at: DateTime.now, type: "StockIncrement" }
  ]
)
puts "#{Stock.count} stocks created successfully!"
