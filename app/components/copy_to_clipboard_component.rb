# frozen_string_literal: true

class CopyToClipboardComponent < ViewComponent::Base
  def initialize(value = "")
    @value = value
  end
end
