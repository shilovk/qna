# frozen_string_literal: true

module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :resource, only: %i[subscribe unsubscribe]
  end

  def subscribe
    resource.subscribe(current_user)
    render 'subscriptions/subscription'
  end

  def unsubscribe
    resource.unsubscribe(current_user)
    render 'subscriptions/subscription'
  end

  private

  def resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
