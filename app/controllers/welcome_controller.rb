class WelcomeController < ApplicationController
  before_action { landing_banner(true) }
  def index
  end
end
