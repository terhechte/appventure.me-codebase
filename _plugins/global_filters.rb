module Jekyll
  module Filters

		def list_of_month_years(posts = nil)
			array = {}
			checkarray = []
			if posts
				# break down into January, 2011 | etc, return
				posts.each { |element| 
						date_string = element.date.strftime('%B %Y')
						if not checkarray.include?(date_string) 
							checkarray.push(date_string)
							array.push([date_string, element.date.strftime('%Y/%m/')])
						end
				}
				return array
			end
		  return []
		end
    
    def excerpt(post = nil)
      content = post['content']
      if content.include?('<!-- more -->')
        "#{content.split('<!-- more -->').first} #{read_more_link post['url']}"
      else
        content
      end
    end
    
    def read_more_link(url = "")
      "<p class=\"continue\"><a href=\"#{url}\">Continue reading this post <span>&rarr;</span></a></p>"
    end
    
    def parameterize(text = "")
      text.gsub(/[^a-z0-9\-_]+/, '-').split('-').delete_if(&:empty?).join('-')
    end
    
    def date_to_words(input = Date.today)
      input.strftime('%B %e, %Y')
    end
    
    def categories_to_sentence(input = [])
      case input.length
        when 0
          ""
        when 1
          link_to_category input[0].to_s
        when 2
          "#{link_to_category input[0]} and #{link_to_category input[1]}"
        else
          "#{input[0...-1].map(&:link_to_category).join(', ')} and #{link_to_category input[-1]}"
      end
    end
    
    def pager_links(pager)

      if pager['previous_page'] || pager['next_page']

        html = '<div class="pager">'
        if pager['previous_page']
          if pager['previous_page'] == 1
            html << "<div class=\"previous\"><p><a href=\"//\">Newer posts &rarr;</a></p></div>"
          else
            html << "<div class=\"previous\"><p><a href=\"/page#{pager['previous_page']}\">Newer posts &rarr;</a></p></div>"
          end
        end

        if pager['next_page'] 
          html << "<div class=\"next\"><p><a href=\"/page#{pager['next_page']}\">&larr; Older posts</a></p></div>"
        end

        html << '</div>'
        html

      end
      
    end

    def mail_to(address = '', text = nil)
      "<a class=\"mailto\" href=\"#{address.to_s.tr("A-Za-z", "N-ZA-Mn-za-m")}\">#{!text ? address.tr("A-Za-z", "N-ZA-Mn-za-m") : text}</a>"
    end
    
  end
end