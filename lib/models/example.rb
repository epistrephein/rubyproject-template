# frozen_string_literal: true

class Example < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  def validate
    super
    validates_presence :name
    validates_unique   :name
  end
end
