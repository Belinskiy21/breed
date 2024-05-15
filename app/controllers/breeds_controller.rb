# frozen_string_literal: true

# This is a root controller
class BreedsController < ApplicationController
  def new
    @img = params[:img]
    @breed = params[:breed]
  end

  def fetch
    service = BreedService.new(params[:breed])
    if service.call
      redirect_to action: :new, img: service.img, breed: service.breed
    else
      flash[:alert] = I18n.t(:no_matches_found)
      redirect_to action: :new
    end
  end
end
