class RegistrationsController < Devise::RegistrationsController
  def create
    logger.debug request.raw_post
    super
    # add custom create logic here
  end

private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :account_type, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :account_type, :password, :password_confirmation, :current_password)
  end
end