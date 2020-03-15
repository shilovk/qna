# frozen_string_literal: true

class AddReferenceInAnswer < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :question, null: false, foreign_key: true
  end
end
