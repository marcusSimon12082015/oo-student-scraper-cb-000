require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      students_array = []
      html_document = Nokogiri::HTML(open(index_url))
      elements= html_document.css(".student-card a")
      elements.collect do |element|
          hash = {}
	        hash[:name] = element.css(".student-name").text
	        hash[:location] = element.css(".student-location").text
          hash[:profile_url] = element["href"]
          students_array << hash
      end
      students_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    #we get all links in container
    hash = {}
    elements = doc.css(".social-icon-container a")
    elements.each do |link|
	     if link["href"].include? "twitter"
         hash[:twitter] = link["href"]
       elsif link["href"].include? "linkedin"
         hash[:linkedin] = link["href"]
       elsif link["href"].include? "github"
         hash[:github] = link["href"]
       else
         hash[:blog] = link["href"]
       end
     end
     quote = doc.css(".vitals-text-container").css(".profile-quote").text
     hash[:profile_quote] = quote
     bio = doc.css(".bio-content").css("p").text
     hash[:bio] = bio
     hash
  end
end
