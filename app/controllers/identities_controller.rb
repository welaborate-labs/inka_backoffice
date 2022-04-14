class IdentitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    @identity = request.env['omniauth.identity']

    if @identity&.errors
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end
end
