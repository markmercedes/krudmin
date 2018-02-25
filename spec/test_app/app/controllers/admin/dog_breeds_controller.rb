require 'open-uri'
require_relative '../../../lib/dogs_api_gateway'

class Admin::DogBreedsController < Krudmin::CustomController
  helper_method :dog_breed

  def index
    @dog_breeds = dogs_api.all
  end

  def show
    @dog_breed = dogs_api.find(dog_breed)
  end

  def dog_breed
    params[:id]
  end

  def dogs_api
    @dogs_api ||= DogsApiGateway.new
  end
end
