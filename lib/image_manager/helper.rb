module Lokka
  module Helpers
    def thumbnail(option = {})
      id = option[:id]
      case option[:target]
      when "category"
        category = Category(id)
        image_url =
          Option.send("image_manager_category_#{category.try(:id)}") ||
          Option.send("image_manager_noimage") ||
          "/plugin/lokka-image_manager/assets/images/noimage.gif"
      when "noimage"
        image_url =
          Option.send("image_manager_noimage") ||
          "/plugin/lokka-image_manager/assets/images/noimage.gif"
      else
        category = Entry(id).category
        image_url =
          Option.send("image_manager_post_#{id}") ||
          Option.send("image_manager_category_#{category.try(:id)}") ||
          Option.send("image_manager_noimage") ||
          "/plugin/lokka-image_manager/assets/images/noimage.gif"
      end
      return %Q|<img src="#{image_url}" style="height:#{option[:height]}px; width:#{option[:width]}px;" class="#{option[:class]}">|
    end

    def has_thumbnail?(option = {})
      if Option.send("image_manager_post_#{option[:id]}")
        true
      else
        false
      end
    end
  end
end
