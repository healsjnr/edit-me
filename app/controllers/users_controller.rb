class UsersController < ApplicationController
  def new
    puts "new called"
  end

  def show
    puts "show called"
    @user = User.find(params[:id])
  end
end
