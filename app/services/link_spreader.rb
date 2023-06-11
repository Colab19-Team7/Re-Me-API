require 'uri'
require 'rest-client'

class LinkSpreader < ApplicationService
    attr_reader :host

    def initialize(link, image = nil)
        @item_link = link
        @original = image
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
        begin
            reponse = RestClient.get(@item_link)
            doc = Nokogiri::HTML(reponse.body)
            title = doc.css("meta[property='og:title']").first[:content]
            image = doc.css("meta[property='og:image']").first[:content]
            description = doc.css("meta[property='og:description']").first[:content]
            { title: title, description: description, item_image: image, item_link: @item_link }
        rescue 
            unknow_link
        end
    end

    def unknow_link
        name = @path&.split('/')&.last&.sub('.html', '')&.gsub(/-/, ' ') || 'No title'
        favicon = @original || "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://#{@host}"
        { title: name, description: '', item_image: favicon, item_link: @item_link}
    end

    def videos_id
        queries = URI.decode_www_form(@query || '').to_h
        id = queries['v']
    end

    def youtube_link
        vido_key = videos_id
        api_key = Rails.application.credentials.youtube_api_key
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
    rescue NoMethodError
        return normal_link
    end
end
