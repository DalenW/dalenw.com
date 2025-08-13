# frozen_string_literal: true

class Form::StackeditComponent < ViewComponent::Base
  def initialize(name, markdownContent)
    @name = name
    @content = markdownContent
  end
end
