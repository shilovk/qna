# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link

    @link.destroy
    message = { notice: 'Your link succesfully deleted.' }
  end
end
