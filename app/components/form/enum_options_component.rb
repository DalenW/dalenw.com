# frozen_string_literal: true

class Form::EnumOptionsComponent < ViewComponent::Base
  def initialize(enum, value)
    @enum = enum
    @value = value
  end
end
