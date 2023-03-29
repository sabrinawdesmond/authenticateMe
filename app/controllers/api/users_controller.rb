class Api::UsersController < ApplicationController
  wrap_parameters include: User.attribute_names + ['password']

  def create
    @user = User.new(user_params)
    render json: user_params

    if @user.save
      login!(user)
      render json: { user: @user.as_json}
    else
      render json: { errors: @user.errors.full_messages }, status: :unproccessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
