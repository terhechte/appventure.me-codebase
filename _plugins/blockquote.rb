module Jekyll

  # Outputs a string with a given attribution as a quote
  #
  #   {% blockquote John Paul Jones %}
  #     Monkeys!
  #   {% endblockquote %}
  #   ...
  #   <blockquote>
  #     Monkeys!
  #     <br />
  #     <strong>John Paul Jones</strong>
  #   </blockquote>
  #
  class Blockquote < Liquid::Block
    TitledCitation = /(\S.*)\s+(https?:\/\/)(\S+)\s+(.+)/i
    Citation = /(\S.*)\s+(https?:\/\/)(\S+)/i
    Author = /([\w\s]+)/

    def initialize(tag_name, markup, tokens)
      @class = ''
      @by = nil
      @source = nil
      @title = nil
      if markup =~ TitledCitation
        @by = $1
        @source = $2 + $3
        @title = $4
      elsif markup =~ Citation
        @by = $1
        @source = $2 + $3
      elsif markup =~ Author
        @by = $1
      end
      super
    end

    def render(context)
      output = super
      parts = ['<blockquote' + @class + '><p>', output]
      parts << "<cite>#{@by}</cite>" if @by
      if @source.nil? && @title.nil?
        parts << '</p></blockquote>'
        return parts.join("\n")
      end

      if !@source.nil?
        cite = "<cite><a href='#{@source}'>#{(@title || source)}</a></cite>"
      elsif !@title.nil?
        cite = "<cite>#{@title}</cite>"
      end

      parts << cite if cite
      parts << '</p></blockquote>'
      parts
    end
  end

  # Outputs a string with a given attribution as a pullquote
  #
  #   {% pullquote John Paul Jones %}
  #     Monkeys!
  #   {% endpullquote %}
  #   ...
  #   <blockquote class="pullquote">
  #     Monkeys!
  #     <br />
  #     <strong>John Paul Jones</strong>
  #   </blockquote>
  #
  class Pullquote < Blockquote
    def render(context)
      @class = ' class="pullquote"'
      super(context)
    end
  end
end

Liquid::Template.register_tag('blockquote', Jekyll::Blockquote)
Liquid::Template.register_tag('pullquote', Jekyll::Pullquote)