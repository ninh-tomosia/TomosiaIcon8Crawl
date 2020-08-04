module TomosiaIcon8Crawl
	require 'open-uri'
	require "HTTParty"
	require 'pry'
	require 'WriteExcel'
    class CrawlIcon8

    	# get data from website
    	def self.json(key, max)
    		if key == nil
    			p "No data!"
    		else 
    			if max == nil
    				url = "https://search.icons8.com/api/iconsets/v5/search?term=#{key}"
    			else
    				url = "https://search.icons8.com/api/iconsets/v5/search?term=#{key}&amount=#{max}"
    			end
    		end
    		
			page_data = HTTParty.get(url)
			@responses = page_data.parsed_response	
    	end

    	# save file to txt
    	def self.save_file_txt(index, name, url, size, extension)   
	      	File.open("log_image.txt", "a+") do |f|
	      		f.write("#{index}. name: #{name} | url: #{url} | size: #{size}Kb | extension: #{extension} \n")
	      	end
    	end

    	# save file to excel
    	def self.save_file_excel( path, data = {})
    		begin
    			des = path + '/export.xls'
    			workbook  = WriteExcel.new(des)
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

    	# download image
    	def self.download_image(path, img)
			File.open(path, 'wb') do |file|
				file.write open(img).read
			end			
    	end

    	# multi download image
    	def self.multi_download_image(path, imgs)
    		threads = []

    		imgs.each_with_index do |img, index|
    			# p index
    			title = File.basename(img, '.png')
    			des = path. + "/" + index.to_s + "-" + title + ".png"
				threads << Thread.new{download_image(des, img)}
				threads.each{ |t| t.join }
			end
    	end

    	# main
        def self.crawl(keyword = nil, path = ".", max = nil)
        	begin
	        	data = []
				images = []
				des = ""
	        	json(keyword, max)
				@responses['icons'].each_with_index do |item, index| 
					title = item['commonName']
					

					src = "https://img.icons8.com/#{item['platform']}/2x/#{item['commonName']}.png"
					# Extension image
					ext = File.extname(src)

					# Name image
					img_name = File.basename(src, ext)

					# add image
					images.push(src)
					
					# Size image
					size = src.size.to_s + 'px'

					# push data
					row = {"index" => index, "name" => img_name, "url" => src, "size" => size, "extension" => ext}
					data.push(row)
				end
				# p data

		        save_file_excel(path, data)
				multi_download_image(path, images)
	    	rescue Exception => e
	    		p "--Runtime error--"
	    		p e
	    	end
	    end

    end
end

# TomosiaIcon8Crawl::CrawlIcon8.crawl("coronavirus")