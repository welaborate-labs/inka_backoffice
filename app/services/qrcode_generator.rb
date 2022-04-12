require 'dotenv'
Dotenv.load('.env')

class QrcodeGenerator
  def initialize(quantity)
    @quantity = quantity
  end

  def create_keys
    IdentificationKey.all.each do |identification|
      identification.destroy! if !identification.present?
    end

    @quantity.times do |i|
      rsa_key = OpenSSL::PKey::RSA.new 512
      private_key_pem = rsa_key.to_pem
      IdentificationKey.create!(private_key: private_key_pem)

      qrcode = RQRCode::QRCode.new IdentificationKey.last.public_key

      png = qrcode.as_png(color: 'black', fill: 'white', size: 300)

      Dir.mkdir("#{ENV['ADDRESS_QRCODE']}") unless Dir.exist? "#{ENV['ADDRESS_QRCODE']}"
      IO.binwrite("#{ENV['ADDRESS_QRCODE']}/#{IdentificationKey.last.id}qrcode.png", png.to_s)
    end
  end
end
