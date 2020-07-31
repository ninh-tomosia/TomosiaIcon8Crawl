# module TomosiaIcon8Crawl
	require 'nokogiri'
	require 'open-uri'
	require 'pry'
	require 'WriteExcel'
    class CrawlIcon8

    	def initialize(keyword, destination, max)
    		@key = keyword
    		@path = destination
    		@max = max
    	end

    	def html
    		url = "https://icons8.com/icons/"
    		if @key != nil
				url += "set/" + @key
			end
			doc = Nokogiri::HTML(URI.open(url))
			@icons = doc.css('.icon')
    	end

    	def save_file_txt(index, name, url, size, extension)   
	      	File.open("log_image.txt", "a+") do |f|
	      		f.write("#{index}. name: #{name} | url: #{url} | size: #{size}Kb | extension: #{extension} \n")
	      	end
    	end

    	# def

        def crawl
        	html
            i = 0
			for i in 0..(@icons.to_a.length - 1)
				unless i >= @max
					begin
						# Title image
						title = @icons.css('.text').to_a[i]
						p i.to_s + " " + title

						# src image
						image = @icons.css('img').to_a[i].to_h['src']
						p image

						# Path download image
						des = @path. + "/" + i.to_s + "-" + title + ".png"
						p des

						# Extension image
						ext = File.extname(image)
						p ext

						# Name image
						img_name = File.basename(image, ext)
						p img_name

						# download image
						File.open(des, 'wb') do |file|
							file.write open(image).read
						end

						# Size image
						size = File.size(des)
						p size

						# Save file
						save_file_txt(i, img_name, image, size , ext)

					rescue Exception => e
						p "--Runtime error--"
						p e
						break
					end
				end
	        end
	    end

    end
# end
CrawlIcon8.new("corona", "../img", 200).crawl