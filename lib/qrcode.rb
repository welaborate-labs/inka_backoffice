require "rqrcode"

class Qrcode
  class << self
    def generate(link)
      RQRCode::QRCode.new(link)

      qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 120
      )

      # IO.binwrite("tmp/qrcode-#{Date.today}.png", png.to_s)
    end
  end
end
