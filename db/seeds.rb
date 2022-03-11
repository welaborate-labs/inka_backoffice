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
