# FlickrAirlift

FlickrAirlift comes with two executables.

### `flickr_airlift`

A command line tool for scraping a given user's photos.
The size/quality of the photos returned depends on the user you auth as.

For example:

  stephenschor:~/Desktop$ flickr_airlift
  Exactly who's photos would you like to archive?:
  Fast & Bulbous
  Fast & Bulbous has 2840 pictures
  * Creating folder named 'Fast & Bulbous'
  * PAGE 1 of 29
  ** Downloading 1: These Words Make No Sense (Original) from http://farm9.staticflickr.com/8231/8592701222_216ddf0db8_o.jpg
  ** Downloading 2: ReLAX (Original) from http://farm9.staticflickr.com/8390/8592703660_8c3de23d6f_o.jpg
  ** Downloading 3: Victrola Arm (Original) from http://farm9.staticflickr.com/8386/8592706290_6462d0264e_o.jpg

### `flickr_uplift`

A command line tool for uploading images from a given directory...

For example:

  stephenschor:~$ pwd
  /Users/stephenschor
  stephenschor:~$ flickr_uplift Pictures/
  Uploading 5 files:
    Uploading (1 of 5): 05517bd3a30b42f902ef032ba21de93a.jpeg
    Uploading (2 of 5): 883197_10151293653430997_2016638279_o.jpg
    Uploading (3 of 5): edhop101.jpg
    Uploading (4 of 5): Judith_Leyster,_Dutch_(active_Haarlem_and_Amsterdam)_-_The_Last_Drop_(The_Gay_Cavalier)_-_Google_Art_Project.jpg
    Uploading (5 of 5): summer-evening.jpeg
  ...DONE!

## Installation

    $ gem install flickr_airlift

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
