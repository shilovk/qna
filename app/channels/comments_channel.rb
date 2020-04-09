# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  include BroadcastQuestion
end
