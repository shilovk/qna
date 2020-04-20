# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, current_user
    render json: current_user
  end

  def index
    authorize! :read, User
    @users = User.where.not(id: current_user.id)
    render json: @users
  end
end
