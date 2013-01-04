require "flickr_airlift/version"
require 'flickraw'
require 'net/http'
require 'cgi'
require 'launchy'
require 'yaml'

module FlickrAirlift

  UPLOADABLE_FORMATS = [".jpg", ".jpeg", ".gif", ".png", ".mov", ".avi"]

  def self.download
    begin
      establish_session

      # Prompt
      puts "Exactly who's photos would you like to archive?:"
      scraped_user = STDIN.gets
      scraped_user = scraped_user.strip

      # Find
      user_id       = flickr.people.findByUsername(:username => scraped_user).id
      photos        = flickr.photos.search(:user_id => user_id)
      photo_count   = photos.total
      page_count    = photos.pages

      # Downloading
      puts "#{scraped_user} has #{photo_count} pictures"
      puts "* Creating folder named '#{scraped_user}'"
      Dir.mkdir(scraped_user) unless File.directory?(scraped_user)

      (1..page_count.to_i).each do |page_number|
        puts "* PAGE #{page_number} of #{page_count}"
        flickr.photos.search(:user_id => user_id, :page => page_number).each_with_index do |photo, i|
          photo_id     = photo.id
          info         = flickr.photos.getInfo(:photo_id => photo_id)
          download_url = flickr.photos.getSizes(:photo_id => photo_id).find{|size| size.label == "Original" || size.label == "Large" || size.label == "Medium"}.source

          puts "** Downloading #{i+1}: #{photo.title} from #{download_url}"
          File.open(File.join(scraped_user, "#{info.title}#{File.extname(download_url)}"), 'wb') do |file|
            file.puts Net::HTTP.get_response(URI.parse(download_url)).body
          end

        end
      end

      rescue FlickRaw::FailedResponse => e
        puts e.msg
      end
  end

  def self.upload(relative_url = ".")
    establish_session

    image_file_names = Dir.entries(relative_url).find_all{ |file_name|  UPLOADABLE_FORMATS.any?{ |extension| file_name.downcase.include?(extension)} }
    uploaded_ids = []

    puts "Uploading #{image_file_names.length} files:"
    sleep 1

    image_file_names.each_with_index do |file_name, index|
      puts "  Uploading (#{index+1} of #{image_file_names.length}): #{file_name}"
      uploaded_ids << flickr.upload_photo(File.join(relative_url, file_name), :title => file_name.split(".").first)
    end

    puts "...DONE!"
    edit_url = "http://www.flickr.com/photos/upload/edit/?ids=#{uploaded_ids.join(',')}"

    Launchy.open(edit_url)
  end

  def self.establish_session
    auth_file               = File.expand_path("~/.flick_airliftrc")
    FlickRaw.api_key        = "3b2360cc04947af8cf59f51c47a6a8e4"
    FlickRaw.shared_secret  = "405549bcec106815"

    if File.exists?(auth_file)
      puts "authenticating through #{auth_file}...if this fails - delete this file"
      data = YAML.load_file(auth_file)
      auth = flickr.auth.checkToken :auth_token => data["api_token"]
    else
      frob                    = flickr.auth.getFrob
      auth_url                = FlickRaw.auth_url :frob => frob, :perms => "write"

      puts " "
      puts "opening your browser..."
      sleep 1
      puts "Come back and press Enter when you are finished"
      sleep 2
      Launchy.open(auth_url)

      STDIN.getc

      # Authentication
      auth  = flickr.auth.getToken :frob => frob
      login = flickr.test.login

      puts auth.token
      data = {}
      data["api_token"] = auth.token
      File.open(auth_file, "w"){|f| YAML.dump(data, f) }
    end
  end

end