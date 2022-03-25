module ApplicationHelper
  def format_currency(amount)
    number_to_currency(amount, unit: 'R$ ', precision: 2, separator: ',', delimiter: '.')
  end
end
