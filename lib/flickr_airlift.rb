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
      puts "Whose photos would you like to archive?:"

      scraped_user = STDIN.gets
      scraped_user = scraped_user.strip

      begin
        user_id = flickr.people.findByUsername(:username => scraped_user).id
      rescue Exception => e
        puts "Hmmmm - unknown user - make sure to use the user's full handle - not the one in the URL. (example: 'Fast & Bulbous' not 'fastandbulbous')"
        self.download
      end

      photos        = flickr.photos.search(:user_id => user_id)
      photo_count   = photos.total
      page_count    = photos.pages

      # non-pro users don't have 'Original' sizes available.
      ranked_sizes  = ['Original', 'Large', 'Medium']

      # Downloading
      puts "#{scraped_user} has #{photo_count} pictures"
      puts "* Creating folder named '#{scraped_user}'"
      Dir.mkdir(scraped_user) unless File.directory?(scraped_user)

      (1..page_count.to_i).each do |page_number|
        puts "* PAGE #{page_number} of #{page_count}"
        flickr.photos.search(:user_id => user_id, :page => page_number).each_with_index do |photo, i|

          photo_id            = photo.id
          downloadable_files  = flickr.photos.getSizes(:photo_id => photo_id)

          ranked_sizes.each do |size_name|
            if df = downloadable_files.find { |downloadable_file| downloadable_file.label == size_name }
              download_url        = df.source
              file_to_write       = File.join(scraped_user, "#{photo_id}#{File.extname(download_url)}")

              if File.exists?(file_to_write) && File.size(file_to_write) > 0
                puts "** SKIPPING #{file_to_write} because it has already been downloaded"
              else
                puts "** Downloading #{i+1}: #{photo.title} (#{size_name}) from #{download_url}"
                File.open(file_to_write, 'wb') { |file| file.puts Net::HTTP.get_response(URI.parse(download_url)).body }
              end
              break
            end
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
    auth_file               = File.join(Dir.home(), ".flick_airliftrc")
    FlickRaw.api_key        = "3b2360cc04947af8cf59f51c47a6a8e4"
    FlickRaw.shared_secret  = "405549bcec106815"

    if File.exists?(auth_file)

      data = YAML.load_file(auth_file)

      begin
        auth = flickr.auth.checkToken :auth_token => data["api_token"]
      rescue Exception => e
        puts "These was a problem with the credentials in #{auth_file}"
        puts "Delete the file and try again."
        exit
      end

    else
      frob     = flickr.auth.getFrob
      auth_url = FlickRaw.auth_url :frob => frob, :perms => "write"

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

      puts "Writing credentials to #{auth_file}"
      data = {}
      data["api_token"] = auth.token
      File.open(auth_file, "w"){|f| YAML.dump(data, f) }
    end
  end

end
