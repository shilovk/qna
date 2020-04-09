# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  before_action :comment, only: %i[update destroy]
  after_action :broadcast_comment, only: :create

  def create
    @comment = @resource.comments.create(comment_params.merge(user_id: current_user.id))
  end

  def update
    return unless current_user&.author?(comment)

    @comment.update(comment_params)
  end

  def destroy
    return unless current_user&.author?(comment)

    @comment.destroy
  end

  private

  def find_resource
    @resource = params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end

  def comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def broadcast_comment
    return if @comment.errors.any?

     question = @resource.is_a?(Question) ? @resource : @resource.question
     gon.question_id = question.id

     CommentsChannel.broadcast_to(question, @comment)
  end
end
