# frozen_string_literal: true

class FluffyCarpet < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def paragraph(text)
    %(<p>#{text}</p>)
  end

  def block_code(code, language)
    case language
    when "mermaid"
       %(<div><pre class="mermaid">#{code}</pre></div>)
    else
      %(<div data-controller="markdown--code" data-markdown--code-language-value="#{language}">#{code}</div>)
    end
  end

end
