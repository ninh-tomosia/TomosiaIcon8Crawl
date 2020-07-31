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

    	def save_file_excel(data = {})
    		begin

    			workbook  = WriteExcel.new('./export.xls')
    			format = workbook.add_format
				format.set_bold()
				format.set_align('center')

				data_col = workbook.add_format
				data_col.set_align('center')
				format_url = workbook.add_format
				format_url.set_color('blue')
				format_url.set_align('center')

	    		worksheet = workbook.add_worksheet

	    		worksheet.write_string(0, 0, 'STT', format)
		    	worksheet.write_string(0, 1, 'NAME', format)
		    	worksheet.write_string(0, 2, 'URL', format)
		    	worksheet.write_string(0, 3, 'SIZE', format)
		    	worksheet.write_string(0, 4, 'EXTENSION', format)

		    	data.each_with_index do |row, index|
		    		i = index + 1
		    		# p i
		    		# p row
		    		row.each do |key, value|
		    			# p key

			    		worksheet.write_string(i, 0, row['index'], data_col)
			    		worksheet.write_string(i, 1, row['name'], data_col)
			    		worksheet.write_url(i, 2, row['url'], format_url)
			    		worksheet.write_string(i, 3, row['size'], data_col)
			    		worksheet.write_string(i, 4, row['extension'], data_col)
		    		end
		    	end

	    		workbook.close
    		rescue Exception => e
    			p "Can't saved file"
    			p e
    			# break
    		end
    	end

        def crawl
        	data = []
        	html
            i = 0
			for i in 0..(@icons.to_a.length - 1)
				unless i >= @max
					begin
						# Title image
						title = @icons.css('.text').to_a[i]
						# p i.to_s + " " + title

						# src image
						image = @icons.css('img').to_a[i].to_h['src']
						# p image

						# Path download image
						des = @path. + "/" + i.to_s + "-" + title + ".png"
						# p des

						# Extension image
						ext = File.extname(image)
						# p ext

						# Name image
						img_name = File.basename(image, ext)
						p img_name

						# download image
						File.open(des, 'w+') do |file|
							file.write open(image).read
						end

						# Size image
						size_n = File.size(des)
						size = size_n.to_s + 'Kb'
						p size

						row = {"index" => i, "name" => img_name, "url" => image, "size" => size, "extension" => ext}
						data.push(row)

						# p data
						# Save file
						# save_file_txt(i, img_name, image, size , ext)
						# save_file_excel(data)

					rescue Exception => e
						p "--Runtime error--"
						p e
						break
					end
				end
	        end
	        save_file_excel(data)
	    end

    end
# end
CrawlIcon8.new("corona", "../img", 10).crawl