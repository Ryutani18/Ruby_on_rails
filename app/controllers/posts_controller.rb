class PostsController < ApplicationController
  before_action :authenticate_user, {only: [:show, :new, :create]}
  before_action :set_tag
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @posts = Post.all.order("id DESC").page(params[:page]).per(4)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @comments = @post.comments
    @like = Like.find_by(user_id: session[:user_id], post_id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      flash[:notice] = :記事を投稿しました
      redirect_to posts_path
    else
      render :new
    end
  end

  def comment
    @post = Post.find(params[:post_id])
    @comment = Comment.new(content: params[:content], user_name: params[:user_name], post_id: params[:post_id])
    if @comment.save
      flash[:notice] = :コメントを投稿しました
      redirect_to @post
    else
      @user = @post.user
      @comments = @post.comments
      @like = Like.find_by(user_id: session[:user_id], post_id: params[:post_id])
      render :show
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    flash[:notice] = :記事を編集しました
    redirect_to @post
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = :記事を削除しました
    redirect_to posts_path
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    if session[:user_id] != @post.user_id
      flash[:notice] = :権限がありません
      redirect_to @post
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

end