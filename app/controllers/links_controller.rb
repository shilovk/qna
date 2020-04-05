# frozen_string_literal: true

class LinksController < ApplicationController
  def destroy
    link = Link.find(params[:id])
    resource = link.linkable

    if current_user.author?(resource)
      link.destroy
      message = { notice: 'Your link succesfully deleted.' }
    else
      message = { alert: 'You are not the author of this resource' }
    end

    if resource.is_a?(Question)
      redirect_to resource, message
    else
      redirect_to resource.question, message
    end
  end
end
