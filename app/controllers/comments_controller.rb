# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  before_action :comment, only: %i[update destroy]
  before_action :load_resource, only: %i[update destroy]
  after_action :broadcast_comment

  authorize_resource

  def create
    @comment = @resource.comments.create(comment_params.merge(user_id: current_user.id))
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def find_resource
    @resource = params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end

  def load_resource
    @resource = @comment.commentable
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
    gon.question_id = question

    CommentsChannel.broadcast_to(question, { comment: @comment, action: params[:action] })
  end
end
