module Jekyll

  class MonthListBlock < Liquid::Block
    include Liquid::StandardFilters

    def render(context)
      posts = context.registers[:site].posts.reverse
			array = []
			checkarray = []
			if posts
				# break down into January, 2011 | etc, return
				posts.each { |element| 
						date_string = element.date.strftime('%B %Y')
						if not checkarray.include?(date_string) 
							checkarray.push(date_string)
              context["monthstring"] = date_string
              context["monthlink"] = element.date.strftime('%Y/%m/')
              array << render_all(@nodelist, context)
						end
				}
      end
    
      array
    end

  end

end

Liquid::Template.register_tag('month_list', Jekyll::MonthListBlock)

# This generates a simple block to create a category list.
#
#  {% category_list %}
#  %li
#    %a{:href => '/{{ category }}'} {{ category | capitalize }}
#  {% endcategory_list %}
