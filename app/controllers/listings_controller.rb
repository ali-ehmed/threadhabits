class ListingsController < ApplicationController
  before_action :authenticate_person!, except: [:show]
  before_action :set_current_person_listing, only: [:edit, :update, :destroy]
  # before_action :fetch_category!, only: [:new, :edit]
  before_action :set_default_request_format, only: [:create, :update]
  before_action :set_listing_data, only: [:new, :edit]

  include Publisher

  def index
    @categories = Category.all
  end

  def new
    @listing = current_person.listings.build
    set_address!(current_person.address)

    @listing.build_address
  end

  def create
    @listing = current_person.listings.build
    change = PlanListing.new(@listing, params)
    change.add_subscriber(PersistenceResponse.new(self))
    change.attributes = listing_params
    change.perform
  end

  def uploads
    listing = Listing.find(fetch_stored_config(:listing_id))
    listing.upload_photos uploads_params[:upload_photos]
    render json: 200
  end

  def destroy_uploads
    upload = Upload.find(params[:upload_id]).destroy
    listing = upload.listing
    if listing.uploads.blank?
      listing.update_attribute(:display_image, nil)
    else
      listing.update_attribute(:display_image, listing.uploads.first.image)
    end
    render json: 200
  end

  def collect_size
    @product_type = ProductType.find(params[:product_type_id])
    @sizes = @product_type.sizes
    respond_to do |format|
      format.js
    end
  end

  def show
    @listing = Listing.includes(:uploads).find_by_slug(params[:slug])
    redirect_to root_path, flash: { alert: "Page not found" } unless @listing

    @uploads = @listing.uploads

    set_geocode_location!(@listing.address)
    respond_to do |format|
      format.html do |html|
        html.phone
      end
    end
  end

  def edit
    set_address!(@listing.address)
  end

  def update
    change = PlanListing.new(@listing, params)
    change.add_subscriber(PersistenceResponse.new(self))
    change.attributes = listing_params
    change.perform
  end

  def destroy
    @listing.destroy
    redirect_to root_path, notice: "Your listing has been sucessfully removed."
  end

  class PersistenceResponse < SimpleDelegator
    def listing_updated(listing)
      unless params[:attribute_name]
        flash[:notice] = "Your Product has been Saved Sucessfully"
      end
      render json: { status: 200, redirect_to: root_path }
    end

    def listing_failed(status = false)
      render json: status
    end
  end

  private

    def set_default_request_format
      request.format = :json unless params[:format]
    end

    # Not being used anymore
    def fetch_category!
      @category = if params[:category_slug].present?
                    Category.find_by_slug(params[:category_slug])
                  elsif @listing
                    @listing.category
                  end
      redirect_to listings_path if !@category
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

    def set_listing_data
      @products = ProductType.all
      @designers = Designer.all
    end

    def set_current_person_listing
      add_subscriber(self)
      @listing = Listing.includes(:uploads).find_by_slug(params[:slug])
      if (!@listing || (current_person and !@listing.belongs_to_person?(current_person))) and !current_person.admin?
        redirect_to root_path, flash: { alert: "Page not found" }
      end
    end

    def set_address!(address)
      @address = address
      if @address.present?
        set_geocode_location!(@address)
      end
    end
end
