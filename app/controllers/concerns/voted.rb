# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :resource, only: %i[up down]
  end

  def up
    resource.vote_up unless current_user.author?(resource)

    render json: { score: resource.score }
  end

  def down
    resource.vote_down unless current_user.author?(resource)

    render json: { score: resource.score }
  end

  private

  def resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
