class AttachmentsController < ApplicationController
  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    resource = attachment.record

    if current_user.author?(resource)
      attachment.purge
      message = { notice: 'Your file succesfully deleted.' }
    else
      message = { alert: 'You are not the author of this resource.' }
    end

    if resource.is_a?(Question)
      redirect_to resource, message
    else
      redirect_to resource.question, message
    end
  end
end
