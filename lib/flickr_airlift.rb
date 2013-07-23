require "flickr_airlift/version"
require "flickr_airlift/downloader"
require 'flickr_authentication'
require 'net/http'
require 'cgi'
require 'highline/import'

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
        user    = flickr.people.findByUsername(:username => scraped_user)
        user_id = user.id
      rescue Exception => e
        puts "Hmmmm - unknown user - make sure to use the user's full handle - not the one in the URL. (example: 'Fast & Bulbous' not 'fastandbulbous')"
        self.download
      end

      # Grab sets
      photo_sets = flickr.photosets.getList(:user_id => user_id).sort_by(&:title)

      choose do |menu|
        menu.prompt = "What do you want to download?"

        menu.choice("~ Entire Photostream ~") do
          FlickrAirlift::Downloader.download(user)
          exit
        end

        photo_sets.each do |photoset|
          menu.choice(photoset.title) do
            FlickrAirlift::Downloader.download(user, photoset)
            exit
          end
        end

        menu.choice("Quit")             { exit }
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
    fa = FlickrAuthentication.new(key: '3b2360cc04947af8cf59f51c47a6a8e4', shared_secret: '405549bcec106815', auth_file: File.join(Dir.home, ".flick_airliftrc"))
    fa.authenticate
  end

end
