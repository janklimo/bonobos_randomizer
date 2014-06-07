require "rubygems"
require "json"
require "net/http"
require 'open-uri'
require 'nokogiri'

class OutfitController < ApplicationController

  def index
   
    populate_arrays

    # load the last outfit to show on homepage
    @last_outfit = Outfit.last

    # if no outfits exist, create one so it's displayed at homepage
    if !Outfit.exists?(1) 
      first = Outfit.new()
      first.shirt = "http://www.bonobos.com/bright-blue-gingham-spread-collar-dress-shirt-for-men"
      first.blazer = "http://www.bonobos.com/indigo-blue-italian-linen-herringbone-blazer-for-men"
      first.tie = "http://www.bonobos.com/americano-necktie-in-seafoam-foulard"
      first.pocket_square ="http://www.bonobos.com/cotton-blue-gingham-pocket-square-for-men"
      first.belt = "http://www.bonobos.com/blue-silk-foulard-belts-for-men"
      first.pants = "http://www.bonobos.com/austin-asphalt-grey-travel-jeans-for-men"
      first.bag = "http://www.bonobos.com/billykirk-schoolboy-satchel-tan"
      first.socks = "http://www.bonobos.com/spots-and-zig-zags-corgi-dress-socks-for-men"
      first.shoes = "http://www.bonobos.com/navy-del-toro-prince-albert-slipper-for-men"

      first.save
    end
  end

  def home

  end

  def create
    # 1. instantiate
    @outfit = Outfit.new(outfit_params)
    # 2. save 
    if @outfit.save
    # 3. redirect if successful
      flash[:notice] = "Outfit created successfully."
      redirect_to(:action => 'view', :id => @outfit.id)
    else
    # 4. redisplay if failed
      render('index')
    end
  end

  
  def view
  	# parse ID
  	# populate place holders
  	# show total price
  	# load sharing scripts with preset images

    #load JSON and process
    populate_arrays

    # check for outfit ID. If none provided, render index
    if params[:id].to_i > 0
      @outfit = Outfit.find(params[:id])
    else 
      render('index')
    end

    #returns e.g. 'blazer'
    load_item = params['more']

    # prevent error when non-existing column name is provided
    if load_item == 'blazer' || load_item == 'shirt' || load_item == 'tie' || load_item == 'pocket_square' || load_item == 'belt' || load_item == 'pants' || load_item == 'bag' || load_item == 'socks' || load_item == 'shoes'
      item_url = @outfit[load_item]
      doc = Nokogiri::HTML(open(item_url))
      
      @further_images = doc.css('a.more-views-thumbs').map { |link| link['href'] }

    end

  end

private
  def outfit_params
    params.require(:outfit).permit(:shirt, :blazer, :tie, :pocket_square, :belt, :pants, :bag, :socks, :shoes)
  end

  def load_json(url)
    uri = URI.parse(url)
   
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
   
    response = http.request(request)
    result = JSON.parse(response.body)
    return result
  end

  def populate_arrays
      #load shirts
      result = load_json("http://bonobos.com/b/dress-shirts-for-men.json")

      @shirts_names_array = Array.new()
      @shirts_prices_array = Array.new()
      @shirts_links_array = Array.new()
      @shirts_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
        category['products'].each do |product|
          @shirts_names_array << product['name']
          @shirts_prices_array << product['price']
          @shirts_links_array << "http://www.bonobos.com/" + product['url_path']
          @shirts_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
        end
      end

      #load blazers
      result = load_json("http://www.bonobos.com/b/mens-suits.json")

      @blazers_names_array = Array.new()
      @blazers_prices_array = Array.new()
      @blazers_links_array = Array.new()
      @blazers_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
        if category["name"] == "Slim Blazers" || category["name"] == "Blazers"
          category['products'].each do |product|
            @blazers_names_array << product['name']
            @blazers_prices_array << product['price']
            @blazers_links_array << "http://www.bonobos.com/" + product['url_path']
            @blazers_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
        end
      end

      #load ties, pocket squares, belts
      result = load_json("http://bonobos.com/b/accessories-for-men.json")

      @ties_names_array = Array.new()
      @ties_prices_array = Array.new()
      @ties_links_array = Array.new()
      @ties_thumbnails_array = Array.new()

      @ps_names_array = Array.new()
      @ps_prices_array = Array.new()
      @ps_links_array = Array.new()
      @ps_thumbnails_array = Array.new()

      @belts_names_array = Array.new()
      @belts_prices_array = Array.new()
      @belts_links_array = Array.new()
      @belts_thumbnails_array = Array.new()

      @socks_names_array = Array.new()
      @socks_prices_array = Array.new()
      @socks_links_array = Array.new()
      @socks_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
        if category["name"] == "Americano Neckties" || category["name"] == "Ties"
          category['products'].each do |product|
            @ties_names_array << product['name']
            @ties_prices_array << product['price']
            @ties_links_array << "http://www.bonobos.com/" + product['url_path']
            @ties_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
        
        elsif category["name"] == "Pocket Squares"
          category['products'].each do |product|
            @ps_names_array << product['name']
            @ps_prices_array << product['price']
            @ps_links_array << "http://www.bonobos.com/" + product['url_path']
            @ps_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end

        elsif category["name"] == "Belts"
          category['products'].each do |product|
            @belts_names_array << product['name']
            @belts_prices_array << product['price']
            @belts_links_array << "http://www.bonobos.com/" + product['url_path']
            @belts_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end

        elsif category["name"] == "Socks"
          category['products'].each do |product|
            @socks_names_array << product['name']
            @socks_prices_array << product['price']
            @socks_links_array << "http://www.bonobos.com/" + product['url_path']
            @socks_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
        end
      end

      # load pants
      result = load_json("http://bonobos.com/b/mens-pants.json")

      @pants_names_array = Array.new()
      @pants_prices_array = Array.new()
      @pants_links_array = Array.new()
      @pants_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
          category['products'].each do |product|
            @pants_names_array << product['name']
            @pants_prices_array << product['price']
            @pants_links_array << "http://www.bonobos.com/" + product['url_path']
            @pants_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
      end

      #load bags
      result = load_json("http://bonobos.com/b/bags-for-men.json")

      @bags_names_array = Array.new()
      @bags_prices_array = Array.new()
      @bags_links_array = Array.new()
      @bags_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
        if category["name"] != "Travel"
          category['products'].each do |product|
            @bags_names_array << product['name']
            @bags_prices_array << product['price']
            @bags_links_array << "http://www.bonobos.com/" + product['url_path']
            @bags_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
        end
      end

      #load shoes
      result = load_json("http://bonobos.com/b/mens-shoes.json")

      @shoes_names_array = Array.new()
      @shoes_prices_array = Array.new()
      @shoes_links_array = Array.new()
      @shoes_thumbnails_array = Array.new()

      result['sub_categories'].each do |category|
        if category["name"] != "Casual"
          category['products'].each do |product|
            @shoes_names_array << product['name']
            @shoes_prices_array << product['price']
            @shoes_links_array << "http://www.bonobos.com/" + product['url_path']
            @shoes_thumbnails_array << "http://www.bonobos.com/media/catalog/product" + product['thumbnail']
          end
        end
      end

    # initiate random ID for outfits to use in the submit form
    @random_shirt = rand(@shirts_names_array.count)
    @random_blazer = rand(@blazers_names_array.count)
    @random_tie = rand(@ties_names_array.count)
    @random_ps = rand(@ps_names_array.count)
    @random_belt = rand(@belts_names_array.count)
    @random_pants = rand(@pants_names_array.count)
    @random_bag = rand(@bags_names_array.count)
    @random_socks = rand(@socks_names_array.count)
    @random_shoes = rand(@shoes_names_array.count)

  end
end