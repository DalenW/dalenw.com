# frozen_string_literal: true

# https://github.com/vmg/redcarpet#block-level-calls
class FluffyCarpet < Redcarpet::Render::HTML
  # include Redcarpet::Render::SmartyPants # causes some issues with code rendering
  include TablerIconsRuby::Helper

  def image(link, title, alt_text)
    %(
    <div class="relative group" data-controller="components--expand-image">
      <img src="#{link}" alt="#{alt_text}" loading="lazy" data-title="#{title}" class="relative">
      <div class="absolute top-2 left-2">
        <button class="btn btn-circle btn-sm opacity-0 group-hover:opacity-100 transition-opacity" data-action="components--expand-image#expand">
          #{tabler_icon('arrows-maximize', class: 'h-4 w-4')}
        </button>
      </div>
      <dialog class="modal" data-components--expand-image-target="modal">
        <div class="modal-box w-11/12 max-w-7xl bg-base-200">
          <div class="flex flex-col gap-4">
            <div class="flex justify-between items-center">
              <h3 class="!my-0">Image Preview</h3>
              <div class="flex gap-2">
                <a href="#{link}"
                   class="btn btn-sm"
                   download
                   title="Download image">
                  #{tabler_icon('download', class: 'h-5 w-5')}
                </a>
                <form method="dialog">
                  <button class="btn btn-sm btn-ghost" title="Close">
                    #{tabler_icon('x', class: 'h-5 w-5')}
                  </button>
                </form>
              </div>
            </div>

            <div class="relative rounded-lg overflow-hidden bg-base-300 p-2">
              <img src="#{link}"
                   class="max-h-[80vh] w-full object-contain !m-0"
                   loading="lazy"
                   alt="#{alt_text}">
            </div>
          </div>
        </div>
        <form method="dialog" class="modal-backdrop">
          <button>close</button>
        </form>
      </dialog>
    </div>
  )
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


        html += %(<div id="#{item_id}" class="carousel-item relative w-full" data-controller="blog--gallery-image">
                    <div class="my-auto">
                      <img src="#{line}" class="object-contain" loading="lazy">
                    </div>
                    <div class="absolute left-5 right-5 top-1/2 flex -translate-y-1/2 transform justify-between align-middle">
                      <div class="flex flex-col align-middle">
                        <a href="##{previous_item_id}" class="btn btn-circle opacity-0">#{tabler_icon('chevron-left', class: 'h-5 w-5')}</a>
                        <a href="##{previous_item_id}" class="btn btn-circle my-2">#{tabler_icon('chevron-left', class: 'h-5 w-5')}</a>
                        <a data-action="blog--gallery-image#expand" class="btn btn-circle">#{tabler_icon('arrows-maximize', class: 'h-5 w-5')}</a>
                      </div>
                      <div class="flex flex-col align-middle">
                        <a href="##{next_item_id}" class="btn btn-circle opacity-0">#{tabler_icon('chevron-right', class: 'h-5 w-5')}</a>
                        <a href="##{next_item_id}" class="btn btn-circle my-2">#{tabler_icon('chevron-right', class: 'h-5 w-5')}</a>
                        <a href="##{next_item_id}" class="btn btn-circle opacity-0">#{tabler_icon('chevron-right', class: 'h-5 w-5')}</a>
                      </div>
                    </div>
                    <dialog class="modal" data-blog--gallery-image-target="modal">
                      <div class="modal-box w-11/12 max-w-7xl bg-base-200">
                        <div class="flex flex-col gap-4">
                          <div class="flex justify-between items-center">
                            <h3 class="!my-0">Image Preview</h3>
                            <div class="flex gap-2">
                              <a href="#{line}"
                                 class="btn btn-sm"
                                 download
                                 title="Download image">
                                #{tabler_icon('download', class: 'h-5 w-5')}
                              </a>
                              <form method="dialog">
                                <button class="btn btn-sm btn-ghost" title="Close">
                                  #{tabler_icon('x', class: 'h-5 w-5')}
                                </button>
                              </form>
                            </div>
                          </div>

                          <div class="relative rounded-lg overflow-hidden bg-base-300 p-2">
                            <img src="#{line}"
                                 class="max-h-[80vh] w-full object-contain !m-0"
                                 loading="lazy">
                          </div>
                        </div>
                      </div>
                      <form method="dialog" class="modal-backdrop">
                        <button>close</button>
                      </form>
                    </dialog>
                  </div>)
      end

      html += %(</div><div class="flex w-full justify-center gap-2 py-2">)

      lines_length.times do |index|
        item_id = "#{parent_id}_#{index}"
        html += %(<a href="##{item_id}" class="btn btn-xs link no-underline" data-turbo="false">#{index + 1}</a>)
      end

      html + "</div>\n"
    else # normal
      %(<code class="" data-controller="markdown--code" data-markdown--code-language-value="#{language}">#{code}</code>)
    end
  end

end
