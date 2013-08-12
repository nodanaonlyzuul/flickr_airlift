require "flickr_airlift/version"
require "flickr_airlift/downloader"
require 'flickr_authentication'
require 'net/http'
require 'cgi'
require 'highline/import'

module FlickrAirlift

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

        menu.choice("Quit") { exit }
      end

    rescue FlickRaw::FailedResponse => e
      puts e.msg
    end
  end

  def self.establish_session
    fa = FlickrAuthentication.new(key: '3b2360cc04947af8cf59f51c47a6a8e4', shared_secret: '405549bcec106815', auth_file: File.join(Dir.home, ".flick_airliftrc"))
    fa.authenticate
  end

end
