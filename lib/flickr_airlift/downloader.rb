require 'fileutils'
require "http"

module FlickrAirlift
  module Downloader

    def self.download(user, set = nil)
      # non-pro users don't have 'Original' sizes available.
      ranked_sizes  = ['Original', 'Large', 'Medium']

      username    = user.username
      path        = set.nil? ? username : File.join(username, set.title)
      user_id     = user.id
      photos      = set.nil? ? flickr.photos.search(:user_id => user_id) : flickr.photosets.getPhotos(:photoset_id => set.id)
      photo_count = photos.total
      page_count  = photos.pages

      # Downloading
      puts "#{username} has #{photo_count} pictures"
      puts "* Creating directory: '#{path}'"
      FileUtils.mkdir_p(path) unless File.directory?(path)

      (1..page_count.to_i).each do |page_number|
        puts "* PAGE #{page_number} of #{page_count}"
        iterate_over = set.nil? ? flickr.photos.search(:user_id => user_id, :page => page_number) : photos.photo

        iterate_over.each_with_index do |photo, i|

          photo_id            = photo.id
          downloadable_files  = flickr.photos.getSizes(:photo_id => photo_id)

          ranked_sizes.each do |size_name|
            if df = downloadable_files.find { |downloadable_file| downloadable_file.label == size_name }
              download_url  = df.source
              file_to_write = File.join(path, "#{photo_id}#{File.extname(download_url)}")

              if File.exists?(file_to_write) && File.size(file_to_write) > 0
                puts "** SKIPPING #{file_to_write} because it has already been downloaded"
              else
                puts "** Downloading #{i+1}: #{photo.title} (#{size_name}) from #{download_url}"
                file = File.open(file_to_write, 'wb') { |file| file.puts HTTP.get(download_url).to_s }
              end
              break
            end
          end
        end
      end
    end
  end

end
