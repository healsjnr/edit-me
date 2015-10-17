require 'application_helper'

class UsersController < ApplicationController
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def new
  end

  def show
    user_id = params[:id].to_s
    current_user_id = current_user.id.to_s
    logger.info("UserId: #{user_id} Current User: #{current_user_id}")
    current_user_valid(current_user, user_id) do
       logger.debug "Valid user."
       @user = User.find(user_id)
    end
  end
end
