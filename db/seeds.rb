pass = BCrypt::Password.create('secret')

puts 'creating identities...'
Identity.create!(
  [
    {
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '1199998888',
      password_digest: pass
    },
    { name: 'Jane Doe', email: 'jane.doe@example.com', phone: '1177776666', password_digest: pass }
  ]
)
puts "#{Identity.count} identities created successfully!"

puts 'creating users...'
User.create!(
  [
    {
      provider: 'identity',
      uid: Identity.first.id,
      name: 'Jhon Doe',
      email: 'john.doe@example.com',
      phone: '1199998888'
    },
    {
      provider: 'identity',
      uid: Identity.last.id,
      name: 'Jane Doe',
      email: 'jane.doe@example.com',
      phone: '1177776666'
    }
  ]
)
puts "#{User.count} users created successfully!"

puts 'creating customers...'
5.times do |i|
  m = Customer.new
  m.name = "#{%w[John Jane].sample}#{i}"
  m.email = "email#{i}@example.com"
  m.phone = "119999111#{i}"
  m.address = 'Some random Address'
  m.document = "1112223334#{i}"
  m.avatar.attach(
    io: File.open(File.join(Rails.root, 'spec/fixtures/files/model.png')),
    filename: 'model.png'
  )
  m.save!
end
puts "#{Customer.count} customers created successfully!"

puts 'creating Professionals...'
Professional.create!(
  [
    {
      name: 'John',
      email: 'john.professional@example.com',
      phone: '1111112222',
      address: 'Some random Address',
      document: '11122233344',
      user_id: User.first.id,
      avatar: {
        io: File.open(File.join(Rails.root, 'spec/fixtures/files/model.png')),
        filename: 'model.png'
      }
    },
    {
      name: 'Jane',
      email: 'jane.professional@example.com',
      phone: '1122221111',
      address: 'Some random Address',
      document: '44333222111',
      user_id: User.second.id,
      avatar: {
        io: File.open(File.join(Rails.root, 'spec/fixtures/files/model.png')),
        filename: 'model.png'
      }
    }
  ]
)
puts "#{Professional.count} professionals created successfully!"

puts 'creating Services...'
5.times do |i|
  m = Service.new
  m.title = "title#{i}"
  m.duration = 30
  m.price = 20 + i
  m.is_comissioned = false
  m.professional_id = Professional.first.id
  m.save!
end
# with service ID
5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}#{i}#{i}"
  m.duration = 60
  m.price = 80 + i
  m.is_comissioned = true
  m.service_id = Service.last.id
  m.professional_id = Professional.second.id
  m.save!
end

5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}#{i}#{i}#{i}"
  m.duration = 45
  m.price = 90 + i
  m.is_comissioned = false
  m.professional_id = Professional.second.id
  m.save!
end
puts "#{Service.count} services created successfully!"

puts 'creating Schedules...'
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

puts 'creating Timeslots ...'
year = DateTime.now.year
month = DateTime.now.month
day = DateTime.now.day
hour = 8
starts_at = DateTime.new(year, month, day, hour) - 5.day
ends_at = DateTime.new(year, month, day, hour) + 10.hours
GenerateTimeslotsCommand.new(starts_at: starts_at, ends_at: ends_at).run
puts "#{Timeslot.count} timeslots created successfully!"

puts 'creating Service Bookings...'
Booking.create!(
  [
    {
      notes: 'some note',
      status: 0,
      service_id: Service.second.id,
      customer_id: Customer.first.id,
      booking_datetime: starts_at = DateTime.new(year, month, day, hour) - 1.day
    },
    {
      notes: 'some note_2',
      status: 1,
      service_id: Service.second.id,
      customer_id: Customer.first.id,
      booking_datetime: starts_at = DateTime.new(year, month, day, hour) - 2.day
    },
    {
      notes: 'some note_3',
      status: 2,
      service_id: Service.third.id,
      customer_id: Customer.first.id,
      booking_datetime: starts_at = DateTime.new(year, month, day, hour) - 3.day
    },
    {
      notes: 'some note_3',
      status: 5,
      service_id: Service.third.id,
      customer_id: Customer.first.id,
      booking_datetime: starts_at = DateTime.new(year, month, day, hour) - 4.day
    },
    {
      notes: 'some note_4',
      status: 6,
      service_id: Service.second.id,
      customer_id: Customer.first.id,
      booking_datetime: starts_at = DateTime.new(year, month, day, hour) - 5.day
    }
  ]
)
puts "#{Booking.count} service bookings created successfully!"

puts 'creating Products...'
Product.create!(
  [
    {
      name: 'some product name_1',
      sku: 'SKU01',
      unit: 'kilograma'
    },
    {
      name: 'some product name_2',
      sku: 'SKU02',
      unit: 'kilograma'
    },
    {
      name: 'some product name_3',
      sku: 'SKU03',
      unit: 'kilograma'
    },
    {
      name: 'some product name_4',
      sku: 'SKU04',
      unit: 'litro'
    },
    {
      name: 'some product name_5',
      sku: 'SKU05',
      unit: 'litro'
    },
    {
      name: 'product_6',
      sku: 'PR06SK',
      unit: 'kilograma'
    }
  ]
)
puts "#{Product.count} products created successfully!"

puts 'creating Stocks...'
Stock.create!(
  [
    {
      product_id: Product.first.id,
      quantity: 22,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    },
    {
      product_id: Product.first.id,
      quantity: 2,
      integralized_at: DateTime.now,
      type: "StockDecrement"
    },
    {
      product_id: Product.second.id,
      quantity: 15,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    },
    {
      product_id: Product.third.id,
      quantity: 10,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    },
    {
      product_id: Product.fourth.id,
      quantity: 55,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    },
    {
      product_id: Product.fifth.id,
      quantity: 120,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    },
    {
      product_id: Product.fifth.id,
      quantity: 20,
      integralized_at: DateTime.now,
      type: "StockDecrement"
    },
    {
      product_id: Product.last.id,
      quantity: 20,
      integralized_at: DateTime.now,
      type: "StockIncrement"
    }
  ]
)
puts "#{Stock.count} stocks created successfully!"
