class PlanListing < Struct.new(:listing, :params)
  include Publisher
  attr_accessor :attributes

  def perform
    listing.attributes = @attributes
    listing.generate_slug

    if params[:attribute_name].present?
      publish(:listing_failed, listing.valid_attribute?(params[:attribute_name].to_sym)) and return
    end

    if listing.save
      publish(:store_config, listing_id: listing.id)
      publish(:listing_updated, listing)
    else
      publish(:listing_failed)
    end
  end
end
