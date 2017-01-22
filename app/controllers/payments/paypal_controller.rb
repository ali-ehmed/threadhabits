class Payments::PaypalController < ApplicationController
  protect_from_forgery except: [:webhook]
  before_action :authenticate_person!, except: [:webhook, :confirm]

  def checkout
    @listing = Listing.find(params[:listing_id])
    if !@listing.person.is_seller?
      flash[:alert] = "Can't do payment with paypal at the moment. Contact tech support"
      redirect_to detail_listings_path(@listing.slug) and return
    end

    cost = (@listing.price)

    flash[:notice] = "Thank you for purchasing."

    values = {
            business: @listing.person.paypal_id,
            cmd: "_xclick",
            upload: 1,
            return: "#{Rails.application.secrets.app_host}#{payments_confirm_checkout_path}",
            # invoice: @listing.id,
            amount: cost,
            item_name: @listing.name,
            item_number: @listing.id,
            quantity: '1',
            notify_url: "#{Rails.application.secrets.app_host}/payments/webhook",
            custom: current_person.id
        }
    redirect_to "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  def confirm
    redirect_to "/"
  end

  def webhook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      # if params[:custom].present?
      #   person = Person.find(params[:custom])
      #   # MailCarrier.deliver_now(BraintreeMailer.notify_successfull_purchase(person))
      # end
      # @checkout.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end
end
