# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  include BroadcastQuestion
end
