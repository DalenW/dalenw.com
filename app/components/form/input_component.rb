# frozen_string_literal: true

class Form::InputComponent < ViewComponent::Base
  def initialize(**options)
    super()

    @id = options[:id].blank? ? SecureRandom.alphanumeric(5) : options[:id]
    @name = options[:name]
    @title = options[:title]
    @value = options[:value]
    @placeholder = options[:placeholder]
    @type = options[:type].blank? ? "text" : options[:type]
    @required = options[:required].nil? ? true : options[:required]
    @helper_text = options[:helper_text]
    @read_only = options[:read_only].nil? ? false : options[:read_only]
    @disabled = options[:disabled].nil? ? false : options[:disabled]
    @input_classes = options[:input_classes]
    @autocomplete = options[:autocomplete].blank? ? "off" : options[:autocomplete]
  end
end
