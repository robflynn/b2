class WebsitesController < ApplicationController
  def index
    render json: Website.all
  end

  def show
  end
end
