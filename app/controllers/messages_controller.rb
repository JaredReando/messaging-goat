class MessagesController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @inbox_messages = []
    @sent_messages = []
    if current_user
      @inbox_messages = Message.where("to_user = #{current_user.id}")
      @sent_messages = Message.where("from_user = #{current_user.id}")
    end
    # binding.pry
  end


  def show
    if current_user.id != Message.find(params[:id].to_i).send_to
      redirect_to messages_path
    end
  end

  def new
    @user_select = user_select
    @message = Message.new
  end

  def edit
  end

  def create
    # this feesl hackey. refactor......LATER.
    temp_params = post_params
    temp_params[:created_by] = session[:user_id]
    @message = Message.new(temp_params)
  end

  def update
  end

  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:body, :to)
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
