class Api::BaseController < ActionController::Base
  def authenticate!
    # Pegar o header do request X-Signature
    # Validar se a signature bate com o hash da API key, da API secret, timestamp e a URL do request
  end
end
