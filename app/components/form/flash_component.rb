# frozen_string_literal: true

class Form::FlashComponent < ViewComponent::Base
  def initialize(*)
    super()

    return unless Rails.env.development?

    puts "Rendering Form Flash Component"
  end

  def before_render
    super()

    @flash = flash.clone

    amount = @flash.keys.count
    puts "There are #{amount} flash(s)"
    puts @flash.inspect

    @flash.each do |key, value|
      puts "#{key}, #{value}"
    end
  end
end
