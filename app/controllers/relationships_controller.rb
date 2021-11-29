class RelationshipsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user

  def follow
    @current_user.follow(params[:user_id])
    flash[:notice] = :フォローしました
  end

  def unfollow
    @current_user.unfollow(params[:user_id])
    flash[:notice] = :フォローから外しました
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
