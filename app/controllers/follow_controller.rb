class FollowController < ApplicationController
  before_action :authenticate_person!
  def index
    @followings = current_person.followings
    @followers = current_person.followers
  end

  def create
    @follow = current_person.followings.build(follower_id: params[:follower_id])
    @follow.save
    render :json => { status: 200, url: follow_path(@follow.id), method: :put, followers: @follow.follower.followers.count, followings: @follow.follower.followings.count }
  end

  def update
    @follow = Follow.find(params[:id])
    @follow.destroy
    respond_to do |format|
      format.html { redirect_to follow_index_path }
      format.json { render :json => { status: 200, url: follow_index_path(follower_id: @follow.follower_id), method: :post, followers: @follow.follower.followers.count, followings: @follow.follower.followings.count } }
    end
  end
end
