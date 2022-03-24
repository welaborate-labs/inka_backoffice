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
5.times do |i|
  m = Professional.new
  m.name = "#{%w[John Jane].sample}#{i}"
  m.email = "email#{i}@example.com"
  m.phone = "119999111#{i}"
  m.address = 'Some random Address'
  m.document = "1112223334#{i}"
  m.user_id = User.first.id
  m.avatar.attach(
    io: File.open(File.join(Rails.root, 'spec/fixtures/files/model.png')),
    filename: 'model.png'
  )
  m.save!
end
5.times do |i|
  m = Professional.new
  m.name = "#{%w[John Jane].sample}#{i}"
  m.email = "email#{i}#{i}@example.com"
  m.phone = "119999111#{i}"
  m.address = 'Some random Address'
  m.document = "1112223334#{i}#{i}"
  m.user_id = User.second.id
  m.avatar.attach(
    io: File.open(File.join(Rails.root, 'spec/fixtures/files/model.png')),
    filename: 'model.png'
  )
  m.save!
end
puts "#{Professional.count} professionals created successfully!"

puts 'creating Services...'
5.times do |i|
  m = Service.new
  m.title = "title#{i}"
  m.duration = 120 + i
  m.price = 20 + i
  m.is_comissioned = false
  m.professional_id = Professional.first.id
  m.save!
end
5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}"
  m.duration = 200 + i
  m.price = 50 + i
  m.is_comissioned = true
  m.professional_id = Professional.second.id
  m.save!
end
# with service ID
5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}#{i}"
  m.duration = 600 + i
  m.price = 60 + i
  m.is_comissioned = false
  m.service_id = Service.first.id
  m.professional_id = Professional.first.id
  m.save!
end
5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}#{i}#{i}"
  m.duration = 800 + i
  m.price = 80 + i
  m.is_comissioned = true
  m.service_id = Service.second.id
  m.professional_id = Professional.second.id
  m.save!
end

5.times do |i|
  m = Service.new
  m.title = "title#{i}#{i}#{i}#{i}#{i}"
  m.duration = 900 + i
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
  s.starts_at = '7:00'
  s.ends_at = '18:00'
  s.interval_starts_at = '12:00'
  s.interval_ends_at = '13:00'
  s.professional_id = Professional.first.id
  s.save!
end
7.times do |i|
  s = Schedule.new
  s.weekday = i
  s.starts_at = "#{6 + i}:00"
  s.ends_at = "#{23 - i}:00"
  s.interval_starts_at = '12:00'
  s.interval_ends_at = '13:00'
  s.professional_id = Professional.second.id
  s.save!
end
puts "#{Schedule.count} schedules created successfully!"
