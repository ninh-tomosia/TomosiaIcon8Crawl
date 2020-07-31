class TomosiaIcon8Crawl

	require 'nokogiri'
	require 'open-uri'
	require 'pry'
	require 'roo'

	def crawl(key, path, max)
		# create url
		url = "https://icons8.com/icons/"
		title = ""
		src = ""

		if key != nil
			url += "set/" + key
		end

		p url

		doc = Nokogiri::HTML(URI.open(url))

		icons = doc.css('.icon')

		p icons.to_a.length
		i = 0

		for i in 0..(icons.to_a.length - 1)
			unless i >= max
				begin
					title = icons.css('.text').to_a[i]
					p i.to_s + " " + title

					image = icons.css('img').to_a[i].to_h['src']
					p image

					des = path. + "/" + i.to_s + "-" + title + ".png"
					p des

					ext = File.extname(image)
					p ext
					img_name = File.basename(image, ext)
					p img_name

					File.open(des, 'wb') do |file|
						file.write open(image).read
					end
				rescue
					break
				end
			end
		end
	end
end

TomosiaIcon8Crawl.new.crawl("coronavirus", "./img", 100)
