# frozen_string_literal: true

class LinkSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :created_at, :updated_at
end
