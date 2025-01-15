# frozen_string_literal: true

# https://github.com/vmg/redcarpet#block-level-calls
class FluffyCarpet < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
  include TablerIconsRuby::Helper

  def image(link, title, alt_text)
    %(<img src="#{link}" alt="#{alt_text}" loading="lazy" data-title="#{title}">)
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
      html = %(<div class="carousel carousel-center w-full">)

      parent_id = SecureRandom.alphanumeric(5)

      lines = code.split("\n")
      lines_length = lines.length

      lines.each_with_index do |line, index|
        item_id = "#{parent_id}_#{index}"
        previous_item_id = "#{parent_id}_#{index - 1}"
        next_item_id = "#{parent_id}_#{index + 1}"

        if index.zero?
          previous_item_id = "#{parent_id}_#{lines_length - 1}"
        end

        if index == lines_length - 1
          next_item_id = "#{parent_id}_0"
        end


        html += %(<div id="#{item_id}" class="carousel-item relative w-full">
                    <img src="#{line}" class="object-contain" loading="lazy">
                    <div class="absolute left-5 right-5 top-1/2 flex -translate-y-1/2 transform justify-between">
                      <a href="##{previous_item_id}" class="btn btn-circle">#{tabler_icon('chevron-left', class: 'h-5 w-5')}</a>
                      <a href="##{next_item_id}" class="btn btn-circle">#{tabler_icon('chevron-right', class: 'h-5 w-5')}</a>
                    </div>
                  </div>)
      end

      html += %(</div><div class="flex w-full justify-center gap-2 py-2">)

      lines_length.times do |index|
        item_id = "#{parent_id}_#{index}"
        html += %(<a href="##{item_id}" class="btn btn-xs link no-underline" data-turbo="false">#{index + 1}</a>)
      end

      html + "</div>\n"
    else
      %(<div data-controller="markdown--code" data-markdown--code-language-value="#{language}">#{code}</div>)
    end
  end

end
