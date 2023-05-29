module CreateCategory
    extend ActiveSupport::Concern

    def get_category(link)
        host = LinkSpreader.new(link).host
        @category = Category.find_by(domain: host)
        new_category(host) if @category.nil?
        @current_user.categories << @category unless @current_user.categories.include?(@category)
        return @category
    end

    def new_category(host)
        name = host.split('.')[-2]
        image_link = "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://#{host}"
        @category = Category.new(name: name, domain: host, category_image: image_link)
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity unless @category.save
    end
end