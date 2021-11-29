class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show]}
  before_action :set_tag
  before_action :ensure_correct_user, {only: [:edit, :update]}
  before_action :forbid_login_user, {only: [:signup, :create, :login_form, :login]}
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @likes = @user.likes
    @following_users = @user.following_users
    @follower_users = @user.follower_users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:password] != params[:user][:password_confirmation]
      @error_message = :パスワードが一致しませんでした
      params[:user][:password] = nil
    end
    if @user.save
      flash[:notice] = :登録が完了しました
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    flash[:notice] = :アカウント情報を更新しました
    redirect_to @user
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:notice] = :ログインしました
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      @error_message = :メールアドレスまたはパスワードが間違っています
      @email = params[:email]
      @password = params[:password]
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = :ログアウトしました
    redirect_to root_path
  end

  def ensure_correct_user
    if session[:user_id] != params[:id].to_i
      flash[:notice] = :権限がありません
      redirect_to posts_path
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = :すでにログインしています
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
