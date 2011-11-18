module Lokka
  module ImageManager
    module Base
      module Picasa
        def self.auth?
          @@picasa ||= ::Picasa::Picasa.new

          unless @@picasa.picasa_session.nil?
            return true
          end

          unless @@picasa.login(Option.image_manager_picasa_email, Option.image_manager_picasa_password).nil?
            @@picasa.picasa_session.auth_key
            return true
          end
          false
        end

        def self.register(params)
          email, password = params['picasa_email'], params['picasa_password']
          unless @@picasa.login(email, password).nil?
            Option.image_manager_picasa_email = email
            Option.image_manager_picasa_password = password
            Option.image_manager_picasa_album = params['picasa_album'].blank? ? 'Lokka' : params['picasa_album']
            @@picasa.picasa_session.auth_key
            return true
          end
          false
        end

        def self.upload(params)
          return if params[:file].nil?
          album = Option.picasa_album.blank? ? 'Lokka' : Option.picasa_album

          album_names = []
          @@picasa.albums(:access => 'all').each {|a| album_names.push a.name}
          @@picasa.create_album(:title => album) unless album_names.include?(album)

          @photo = @@picasa.post_photo(
            params[:file][:tempfile].read,
            :album => album,
            :title => params[:file][:filename],
            :description => params[:file][:filename],
            :content_type => params[:file][:type],
            :local_file_name => params[:file][:filename]
          )
          if @photo
            image = PicasaImage.new
            image.service = 'picasa'
            image.url = @photo.url
            image.thumbnail = @photo.thumbnails[1]
            return image
          end
        end
      end

      class PicasaImage < ::Lokka::ImageManager::Image
      end
    end
  end
end
