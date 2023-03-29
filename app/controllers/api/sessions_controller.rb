class Api::SessionsController < ApplicationController
  def show
    if current_user
      render json: { user: current_user.as_json }
    else
      render json: { user: nil }
    end
  end

  def create
    @user = User.find_by_credentials(params[:credential], params[:password])

    if @user
      login!(@user)
      render json: { user: @user.as_json}
    else
      render json: { errors: ['The provided credentials were invalid.'] }, status: :unauthorized
    end
  end

  def destroy
    logout!
    render json: { message: ['success'] }
  end
end
