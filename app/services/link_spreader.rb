require 'uri'
require 'rest-client'

class LinkSpreader < ApplicationService
    attr_reader :message

    def initialize(link)
        @item_link = link
        @link = URI(link)
        @host = @link.host
        @path = @link.path
        @query = @link.query
    end

    def call
        if (@host === 'www.youtube.com') 
            youtube_link
        else
            normal_link
        end
    end

    private

    def normal_link
        name = @path.split('/').last.sub('.html', '').gsub(/-/, ' ')
        favicon = "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://#{@host}"
        { title: name, description: '', item_image: favicon, item_link: @item_link }
    end

    def youtube_link
        vido_key = @query[2..-1]
        api_key = 'AIzaSyBjjAoRaF8PrTvX1b3IXz0ID8WchiEHMOI'
        url = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{vido_key}&key=#{api_key}"

        begin
            reponse = RestClient.get(url)
            reponse = JSON.parse(reponse.body, object_class: OpenStruct)
            name = reponse[:items][0][:snippet][:title]
            description = reponse[:items][0][:snippet][:description]
            image_link = reponse[:items][0][:snippet][:thumbnails][:medium][:url]
            { title: name, description: description, item_image: image_link, item_link: @item_link }
        rescue RestClient::MovedPermanently,
            RestClient::Found,
            RestClient::TemporaryRedirect => err
            render json: { errors: err.response.follow_redirection }, status: :unprocessable_entity
        end
    end
end
