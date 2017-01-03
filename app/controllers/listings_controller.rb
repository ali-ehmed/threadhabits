class ListingsController < ApplicationController
  before_action :authenticate_person!
  before_action :fetch_category!, only: [:new]

  def index
    @categories = Category.all
  end

  def new
    @listing = current_person.listings.build
    @products = ProductType.all
    @designers = Designer.all

    if @listing.has_address?
      set_geocode_location!(@listing.address)
    else
      @listing.build_address
    end
  end

  def create
    @listing = current_person.listings.build
    if @listing.save(listing_params)
      redirect_to root_path, notice: "Your Product has been Published Sucessfully"
    else
      render :new
    end
  end

  def collect_size
    @product_type = ProductType.find(params[:product_id])
    @sizes = @product_type.sizes
    respond_to do |format|
      format.js
    end
  end

  private

    def fetch_category!
      @category = Category.find_by_slug(params[:slug])
      redirect_to listings_path unless @category
    end

    def listing_params
      params.require(:listing).permit(
        :name, :description, :price, :company_id, :category_id, :condition, :sizes,
        :address_attributes => [:id, :location, :place_id, :latitude, :longitude]
      )
    end
end
