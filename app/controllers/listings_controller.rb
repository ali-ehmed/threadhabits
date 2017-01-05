class ListingsController < ApplicationController
  before_action :authenticate_person!
  before_action :fetch_category!, only: [:new]
  before_action :set_default_request_format, only: [:create]
  # before_action :set_listing, only: [:uploads]

  def index
    @categories = Category.all
  end

  def new
    @listing = current_person.listings.build
    @products = ProductType.all
    @designers = Designer.all

    if @listing.has_address?
      @address = @listing.address
    else
      @address = current_person.address
    end

    if @address.present?
      set_geocode_location!(@address)
    end

    @listing.build_address
  end

  def create
    @listing = current_person.listings.build
    respond_to do |format|
      @listing.attributes = listing_params
      if @listing.save
        store_config(listing_id: @listing.id)
        flash[:notice] = "Your Product has been Published Sucessfully"
        format.json { render json: { status: 200, redirect_to: root_path } }
      else
        format.json { render json: { status: false, errors: @listing.errors } }
      end
    end
  end

  def uploads
    listing = Listing.find(fetch_stored_config(:listing_id))
    listing.upload_photos = uploads_params[:upload_photos]
    render json: 200
  end

  def collect_size
    @product_type = ProductType.find(params[:product_type_id])
    @sizes = @product_type.sizes
    respond_to do |format|
      format.js
    end
  end

  private

    def set_default_request_format
      request.format = :json unless params[:format]
    end

    def fetch_category!
      @category = Category.find_by_slug(params[:slug])
      redirect_to listings_path unless @category
    end

    def listing_params
      params.require(:listing).permit(:name, :description, :price, :company_id, :category_id, :condition, :size_id, :product_type_id,
                                      :address_attributes => [:id, :location, :place_id, :latitude, :longitude]
                                     )
    end

    def uploads_params
      params.permit(
        :upload_photos => []
      )
    end

    def set_listing
      @listing = Listing.find(params[:id])
    end
end
