class TagsController < ApplicationController
  before_action :set_tag

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.all.order("id DESC").page(params[:page]).per(4)
  end
  
end
