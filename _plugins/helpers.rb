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
    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      site = @context.registers[:site]
      converter = site.getConverterImpl(Jekyll::MarkdownConverter)
      converter.convert(input)
    end

  end

  Liquid::Template.register_filter(ExtendedFilters)
end