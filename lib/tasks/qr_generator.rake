require_relative '../../app/models/identification_key'
require_relative '../../app/services/qrcode_generator'

namespace :qr_generator do
  desc 'Creates # registers of QRCode in database (args[:quantity])'
  task :create, %i[quantity] => [:environment] do |task, args|
    puts '== Creating Qrcodes =='
    qrCode = QrcodeGenerator.new(args[:quantity].to_i).create_keys
    puts "== #{IdentificationKey.count} created successfully =="
  end
end
