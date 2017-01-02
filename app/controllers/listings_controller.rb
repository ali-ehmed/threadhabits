class ListingsController < ApplicationController
  before_action :authenticate_person!

  def new
  end
end
