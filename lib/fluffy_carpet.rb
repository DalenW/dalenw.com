# frozen_string_literal: true

class FluffyCarpet < Redcarpet::Render::HTML
  # include Redcarpet::Render::SmartyPants

  def paragraph(text)
    %(<p>#{text}</p>)
  end

  def block_code(code, language)
    %(<div data-controller="markdown--code" data-markdown--code-language-value="#{language}" data-markdown--code-code-value="#{code}"></div>)
  end

end
