# frozen_string_literal: true

# https://github.com/vmg/redcarpet#block-level-calls
class FluffyCarpet < Redcarpet::Render::HTML
  # include Redcarpet::Render::SmartyPants # causes some issues with code rendering
  include TablerIconsRuby::Helper

  def image(link, title, alt_text)
    %(<img src="#{link}" alt="#{alt_text}" loading="lazy" data-title="#{title}" data-controller="components--expand-image">)
  end

  def link(link, title, content)
    %(<a class="link link-hover" href="#{link}">#{content}</a>)
  end

  def paragraph(text)
    %(<p>#{text}</p>)
  end

  def block_code(code, language)
    case language
    when "mermaid"
       %(<div><pre class="mermaid">#{code}</pre></div>)
    when "image_gallery"
      image_urls = code.split("\n")
      html = '<div data-controller="blog--image-gallery">'

      image_urls.each do |image_url|
        html += %(<a href="#{image_url}" data-turbo="false" data-pswp-width></a>) # probably won't work because idk the image width and height ahead of time, unless I pass it in the URL or something weird
      end

      html += "</div>"
    else # normal
      %(<code class="" data-controller="markdown--code" data-markdown--code-language-value="#{language}">#{code}</code>)
    end
  end

end
