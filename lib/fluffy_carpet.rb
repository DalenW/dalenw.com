# frozen_string_literal: true

class FluffyCarpet < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def block_code(code, language)
    nil
  end

end
