module Liquid
  
  module ExtendedFilters

    def date_to_month(input)
      Date::MONTHNAMES[input]
    end

    def date_to_month_abbr(input)
      Date::ABBR_MONTHNAMES[input]
    end

    def date_to_utc(input)
      input.getutc
    end

    def preview(text, delimiter = '<!-- end_preview -->')
      if text.index(delimiter) != nil
        text.split(delimiter)[0]
      else
        html_truncatewords(text)
      end
    end

    def markdownify(input)
      Markdown.new(input)
      #markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      #return markdown.render(input)
    end

  end

  Liquid::Template.register_filter(ExtendedFilters)
end