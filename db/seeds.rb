pass = BCrypt::Password.create('secret')

puts 'creating identities...'
Identity.create!(
  [
    { name: 'John Doe', email: 'john.doe@example.com', phone: '1199998888', password_digest: pass },
    { name: 'Jane Doe', email: 'jane.doe@example.com', phone: '1177776666', password_digest: pass }
  ]
)
puts "#{Identity.count} identities created successfully!"
puts 'creating users...'
User.create!(
  [
    { provider: 'identity', uid: Identity.first.id, name: 'Jhon Doe', email: 'john.doe@example.com', phone: '1199998888' },
    { provider: 'identity', uid: Identity.last.id, name: 'Jane Doe', email: 'jane.doe@example.com', phone: '1177776666' }
  ]
)
puts "#{User.count} users created successfully!"
