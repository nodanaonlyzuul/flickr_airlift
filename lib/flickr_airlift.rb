#!/usr/bin/env ruby
require 'rubygems'
require 'flickr'

# Call api_key, secret, user name

def download(options = {})

  # Authentication
  api_key   = "d4d152785af1b0ea68a5a2d173c75707"
  user_name = ARGV.first

  flickr      = Flickr.new('api_key' => api_key)
  user        = flickr.users(user_name)
  photo_count = user.photos.total
  page_count  = user.photos.pages

  # reate folder with name of User
  puts "* Creating folder named '#{user_name}'"
  Dir.mkdir(user_name) unless File.directory?(user_name)

  puts "* #{user_name} has #{photo_count} photos"

  # Begin Downloading
  (1..page_count.to_i).each do |i|
    puts "** Downloading page #{i} of #{page_count}"

    user.photos(:page => i).each_with_index do |photo, index|
      puts "*** saving #{index+1}: '#{photo.title}'"
      File.open(File.join(user_name, photo.filename), 'w') do |file|
        file.puts photo.file("Large")
      end
    end

  end
end

download