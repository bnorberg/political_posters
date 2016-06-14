require 'rubygems'
require 'csv'
require 'open-uri'

class PosterDataSplitter

	def split_metadata
		new_file = ARGV.first
		#### Add values to @region_array the array
		@region_array = ["North America", "West Europe"]
		#### End add values
		@country_array = ["United States", "Germany", "Cuba", "Canada", "France", "United Kingdom", "Country Unknown", "Israel", "Chile", "Poland", "Italy", "Portugal", "Libya", "Ireland", "Netherlands", "Mexico", "Bolivia", "Australia", "Switzerland", "Greece", "Spain", "South Korea", "Philippines", "China (Peoples Republic)"]
		CSV.foreach(ARGV.last, headers:true) do |poster|
			CSV.open(new_file, 'ab') do |csv|
			  	file = CSV.read(new_file,:encoding => "iso-8859-1",:col_sep => ",")
			  	if file.none?
			    	csv << ["id", "title", "creators", "technique", "date", "measurements", "subjects", "materials", "geographic region", "country", "state|city", "text", "notes", "translation", "exhibition", "copyright"]
			  	end
			  	title = poster['title']
			  	poster_metadata = poster['metadata'].gsub("ID Number:", "ID$").gsub("Maker:", "Maker$").gsub("Technique:", "Technique$").gsub("Date Made:", "Date$").gsub("Measurements:", "Measurements$").gsub("Place Made:", "Place$").gsub("Translation:", "Translation$").gsub("Main Subject:", "MainSubject$").gsub("Materials:", "Materials$").gsub("Digitized:", "Digitized$").gsub("Full Text:", "Text$").gsub("Production Notes:", "Notes$").gsub("Notes:", "Notes$").gsub("Acquisition Number:", "AcquisitionNumber$").gsub("Exhibition Annotation:", "ExhibitionAnnotation$").gsub("Copyright Status:", "CopyrightStatus$")
			  	metadata = poster_metadata.split(/(\w*\$)/)
			  	metadata.shift
					#### Add missing values below
			  	metadata_hash = Hash[*metadata]
			  	id = nil_check(metadata_hash['ID$'])
			  	creators = nil_check(metadata_hash['Maker$'])
			  	technique = nil_check(metadata_hash[])
			  	date = nil_check(metadata_hash[])
			  	measurements = nil_check(metadata_hash[])
			  	place = metadata_hash[]
					#### End add missing values
			  	puts place
			  	if !place.nil?
			  		if place.include?(":")
			  			if place.split(":")[1].include?(";")
			  				region = nil_check(place.split(":")[0])
			  				puts region
			  				country = nil_check(place.split(":")[1].split(";")[0])
			  				puts country
			  				city = nil_check(place.split(":")[1].split(";")[1])
			  				puts city
			  			else
			  				if @region_array.include?(nil_check(place.split(":")[0]))
			  					region = nil_check(place.split(":")[0])
			  					puts region
			  					country = nil_check(place.split(":")[1])
			  					puts city
			  				else
			  					country = nil_check(place.split(":")[0])
			  					puts country
			  					city = nil_check(place.split(":")[1])
			  					puts city
			  				end
			  			end
			  		else
			  			if @country_array.include?(nil_check(place))
			  				country = nil_check(place)
			  			else
			  				city = nil_check(place)
			  			end
			  		end
			  	else
			  		continent = nil
			  		country = nil
			  		city = nil
			  	end
			  	subjects = nil_check(metadata_hash['MainSubject$'])
			  	materials = nil_check(metadata_hash['Materials$'])
			  	notes = nil_check(metadata_hash['Notes$'])
			  	text = nil_check(metadata_hash['Text$'])
			  	translation = nil_check(metadata_hash['Translation$'])
			  	exhibition = nil_check(metadata_hash['ExhibitionAnnotation$'])
			  	copyright = nil_check(metadata_hash['CopyrightStatus$'])
					image_name = "/#{ARGV.first.split("/")[1..2].join("/")}/#{id}.jpg"
					image = poster['master_image']
					#thumb_name = "/#{ARGV.first.split("/")[1..2].join("/")}/#{id}_thumbnail.jpg"
					thumbnail = poster['image_thumb']
			  	download_image(image_name, image)
			  	#download_image(thumb_name, thumbnail)
			  	csv << [id, title, creators, technique, date, measurements, subjects, materials, region, country, city, text, notes, translation, exhibition, copyright]
			  	puts "-----------------------"
			 end
		end
	end

	def nil_check(content)
		if !content.nil?
			content.strip
		else
			content
		end
	end

	def download_image(name, image)
		File.open(name,'wb') do |fo|
			fo.write open(image).read
		end
	end

end

	posters = PosterDataSplitter.new
	posters.split_metadata
