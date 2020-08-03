module TomosiaIcon8Crawl
	require 'open-uri'
	require "HTTParty"
	require 'pry'
	require 'WriteExcel'
    class CrawlIcon8

    	def initialize(keyword, destination, max)
    		@key = keyword
    		@path = destination
    		@max = max
    	end

    	def html
    		if @key == nil
    			p "No data!"
    		else 
    			if @max == nil
    				url = "https://search.icons8.com/api/iconsets/v5/search?term=#{@key}"
    			else
    				url = "https://search.icons8.com/api/iconsets/v5/search?term=#{@key}&amount=#{@max}"
    			end
    		end
    		
			page_data = HTTParty.get(url)
			@responses = page_data.parsed_response	
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
        	begin
	        	data = []
	        	html
				@responses['icons'].each_with_index do |item, index| 
					title = item['commonName']
					des = @path. + "/" + index.to_s + "-" + title + ".png"

					src = "https://img.icons8.com/#{item['platform']}/2x/#{item['commonName']}.png"
					# Extension image
					ext = File.extname(src)

					# Name image
					img_name = File.basename(src, ext)

					# download image
					File.open(des, 'wb') do |file|
						file.write open(src).read
					end

					# Size image
					size_n = File.size(des)
					size = size_n.to_s + 'Kb'

					# push data
					row = {"index" => index, "name" => img_name, "url" => src, "size" => size, "extension" => ext}
					data.push(row)
				end
				p data
		        save_file_excel(data)
	    	rescue Exception => e
	    		p "--Runtime error--"
	    		p e
	    	end
	    end

    end
end