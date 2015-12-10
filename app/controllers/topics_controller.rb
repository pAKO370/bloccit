class TopicsController < ApplicationController
  before_action :require_sign_in, except: [:index, :show]
  before_action :authorize_user



  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new 
    @topic = Topic.new
  end

  def create
    
      @topic = Topic.new(topic_params)

      if @topic.save
        redirect_to @topic, notice: "Topic was saved successfully."
      else
        flash[:error] = "Error creating topic. Please try again."
        render :new
      end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])


    @topic.assign_attributes(topic_params)

    if @topic.save
      flash[:notice] = "Topic was updated."
      redirect_to @topic
    else
      flash[:error] = "Error saving topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])

    if @topic.destroy
      flash[:notice] = "\"#{@topic.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end
  end

private
  def topic_params
    params.require(:topic).permit(:name, :description, :public)
  end

  def authorize_user
    if params[:action] == 'update' || params[:edit] == 'edit' || params[:action] == 'new' || params[:action] == 'create'
      unless current_user.admin? || current_user.moderator?
        flash.now[:alert] = "You must be an admin to do that"
        redirect_to topics_path
      end

    elsif params[:action] == 'destroy'
      unless current_user.admin?
        flash.now[:alert] = "You must be an admin to do that"
        redirect_to topics_path
      end
    end
  end

end
