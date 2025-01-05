# frozen_string_literal: true

class Form::ErrorComponent < ViewComponent::Base
  def initialize(message_hash)
    @messages = message_hash
  end
end
