class HomeController < ApplicationController
  before_action { landing_banner(true) }
  before_action :filter_data, only: [:index, :fetch_listings]
  before_action :authenticate_person!, only: [:verify_unread_message]

  def index
    if @p[:filters] and params[:q].present?
      @p[:filters].merge!(q: params[:q])
    end

    @listings = Listing.fetch_by_filters(@p[:filters]).paginate(:page => params[:page], :per_page => Listing::PER_PAGE)
  end

  def verify_unread_message
    message = current_person.received_messages.order("created_at desc").first
    read = true
    if message.present?
      read = message.has_read?
    end
    render json: { status: 200, unread: read }
  end

  private

  def filter_data
    @categories  = Rails.cache.fetch("categories", expires_in: 1.hour) do
                      Category.all
                    end
    @designers   =  Rails.cache.fetch("designers", expires_in: 1.hour) do
                      Designer.all
                    end
    @tops        =  Rails.cache.fetch("tops", expires_in: 1.hour) do
                      Size.tops
                    end
    @bottoms     =  Rails.cache.fetch("bottoms", expires_in: 1.hour) do
                      Size.bottoms
                    end
    @shoes       =  Rails.cache.fetch("shoes", expires_in: 1.hour) do
                      Size.shoes
                    end
    @accessories =  Rails.cache.fetch("accessories", expires_in: 1.hour) do
                      Size.accessories
                    end
    @condtions = Listing::CONDITIONS
  end
end
