# frozen_string_literal: true

namespace :gift_cards do
  task generate_qrcodes: :environment do
    include Rails.application.routes.url_helpers

    GiftCard.find_each do |gift_card|
      qrcode = RQRCode::QRCode.new(gift_card_url(gift_card, :host => 'www.inkabeautyspa.com.br'))

      svg = qrcode.as_svg(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 11,
        standalone: true,
        use_path: true
      )

      IO.binwrite("/storage/gift_cards/qrcode-#{gift_card.id}.svg", svg.to_s)
    end
  end
end
