class TomosiaIcon8Crawl

	require 'nokogiri'
	require 'open-uri'
	require 'pry'
	require 'image_size'
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

					# image_size = ImageSize.path(des)
					# p image_size.size

					# 

					ext = File.extname(image)
					p ext
					img_name = File.basename(image, ext)
					p img_name

					File.open(des, 'wb') do |file|
						file.write open(image).read
					end

					# File.open(des, 'w+') do |img|
					# 	ims = ImageSize.new(img)
					# 	p ims.size
					# end
					size = File.size(des)
					p size

					workbook = Roo::Spreadsheet.open './log.xlsx'
					worksheets = workbook.sheets
					puts "Found #{worksheets.count} worksheets"

					worksheets.each do |worksheet|
					  	puts "Reading: #{worksheet}"
					  	num_rows = 0
					  	workbook.sheet(worksheet).each_row_streaming do |row|
					    row_cells = row.map { |cell| cell.value }
					    num_rows += 1
					  end
					  puts "Read #{num_rows} rows" 
					end
				rescue Exception => e
					p e
					break
				end
			end
		end
	end
end

TomosiaIcon8Crawl.new.crawl("coronavirus", "./img", 100)
