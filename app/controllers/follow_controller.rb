class FollowController < ApplicationController
  def index
    @followings = current_person.followings
    @followers = current_person.followers
  end

  def create
    @follow = current_person.followings.build(follower_id: params[:follower_id])
    @follow.save
    render :json => { status: 200, url: follow_path(@follow.id), method: :put, followers: current_person.followers.count, followings: current_person.followings.count }
  end

  def update
    @follow = Follow.find(params[:id])
    @follow.destroy
    render :json => { status: 200, url: follow_index_path(follower_id: @follow.follower_id), method: :post, followers: current_person.followers.count, followings: current_person.followings.count }
  end
end
