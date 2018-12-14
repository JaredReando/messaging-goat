class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @inbox_messages = []
    @sent_messages = []
    if current_user
      @inbox_messages = Post.where("send_to = #{session[:user_id]}")
      @sent_messages = Post.where("created_by = #{session[:user_id]}")
    end
  end


  def show
    if current_user.id != Post.find(params[:id].to_i).send_to
      redirect_to posts_path
    end
  end

  def new
    @user_select = user_select
    @post = Post.new

  end


  def edit
  end

  def create

    # this feesl hackey. refactor......LATER.
    temp_params = post_params
    temp_params[:created_by] = session[:user_id]
    @post = Post.new(temp_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :send_to)
    end

    def user_select
      users = User.all
      users_array = []
      users.each do |user|
        users_array.push([user.email,user.id])
      end
      users_array
    end



end
