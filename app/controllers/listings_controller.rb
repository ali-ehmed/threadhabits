class ListingsController < ApplicationController
  before_action :authenticate_person!
  before_action :fetch_category!, only: [:new]

  def index
    @categories = Category.all
  end

  def new
    @listing = current_person.listings.build
  end

  def create
    @listing = current_person.listings.build
    if @listing.save(listing_params)
      redirect_to root_path, notice: "Your Product has been Published Sucessfully"
    else
      render :new
    end
  end

  private

    def fetch_category!
      @category = Category.find_by_slug(params[:slug])
      redirect_to listings_path unless @category
    end

    def listing_params
      params.require(:listing).permit(:name, :description, :price, :category_id, :condition)
    end
end
