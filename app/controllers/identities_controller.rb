class IdentitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    @identity = request.env['omniauth.identity']
  end
end
