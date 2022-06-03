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
  m.title = "title#{i}#{i}#{i}"
  m.duration = 45
  m.price = 60 + i
  m.is_comissioned = false
  m.service_id = Service.last.id
  m.professional_id = Professional.first.id
  m.save!
end
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
  m.service_id = Service.second.id
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
starts_at = DateTime.new(2022, 5, 1, 00)
ends_at = DateTime.new(2022, 5, 21, 00)
GenerateTimeslotsCommand.new(starts_at: starts_at, ends_at: ends_at).run
puts "#{Timeslot.count} timeslots created successfully!"

puts 'creating Service Bookings...'
ServiceBooking.create!(
  [
    {
      notes: 'some note',
      status: 0,
      service_id: Service.first.id,
      customer_id: Customer.first.id,
      booking_datetime: '2022-05-01 08:00'
    },
    {
      notes: 'some note_2',
      status: 1,
      service_id: Service.first.id,
      customer_id: Customer.first.id,
      booking_datetime: '2022-05-01 09:00'
    },
    {
      notes: 'some note_3',
      status: 2,
      service_id: Service.first.id,
      customer_id: Customer.first.id,
      booking_datetime: '2022-05-03 08:00'
    },
    {
      notes: 'some note_3',
      status: 5,
      service_id: Service.first.id,
      customer_id: Customer.first.id,
      booking_datetime: '2022-05-05 15:00'
    },
    {
      notes: 'some note_4',
      status: 6,
      service_id: Service.last.id,
      customer_id: Customer.first.id,
      booking_datetime: '2022-05-18 10:00'
    }
  ]
)
puts "#{ServiceBooking.count} service bookings created successfully!"
