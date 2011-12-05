require 'hpricot'
require 'nokogiri'

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

    def html_truncatewords(text, max_length = 200, ellipsis = "")
      ellipsis_length = ellipsis.length     
      doc = Nokogiri::HTML::DocumentFragment.parse text
      content_length = doc.inner_text.length
      actual_length = max_length - ellipsis_length
      content_length > actual_length ? doc.truncate(actual_length).inner_html + ellipsis : text.to_s
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
    end

  end

  Liquid::Template.register_filter(ExtendedFilters)
end