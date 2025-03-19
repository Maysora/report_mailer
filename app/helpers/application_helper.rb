require 'redcarpet/render_strip'

module ApplicationHelper
  def n2br text
    return text if text.blank?
    safe_join(text.split("\n"), tag.br)
  end

  def render_markdown(text, format: :html, remove_comment: '//', **extensions)
    if remove_comment
      text.gsub!(/^#{Regexp.escape('//')}.+$/, '')
    end
    @markdowns ||= {}
    if @markdowns[format].nil?
      extensions.reverse_merge!(no_intra_emphasis: true, fenced_code_blocks: true, disable_indented_code_blocks: true, highlight: true)
      @markdowns[format] = Redcarpet::Markdown.new(
        case format
        when :html
          Redcarpet::Render::HTML
        else
          Redcarpet::Render::StripDown
        end, **extensions)
    end
    @markdowns[format].render(text).html_safe
  end
end
