require 'image_manager/base/picasa'

module Lokka
  module ImageManager
    module Base
      def self.auth?
        ImageManager::EXTERNAL.each do |service|
          return true if get_class(service).auth?
        end
        false
      end

      def self.register(params)
        get_class(params[:service]).register(params)
      end

      def self.upload(params)
        if object = get_class(params[:service]).upload(params)
          save object
        end
      end

      def self.thumbnail(params)
        if object = get_class(params[:service]).upload(params)
          correlation(params, object.url)
          save object
        end
      end

      def self.delete(params)
        Option.send(column(params), nil)
      end

      def self.correlation(params, url)
        Option.send(column(params), url)
      end

      def self.save(obj)
        if array = load_image
          array << obj
        else
          array = [obj]
        end
        dump_image(array)
      end

      def self.dump_image(array)
        return nil unless array
        Option.image_manager = unpack(Zlib::Deflate.deflate(unpack(Marshal.dump(array))))
      end

      def self.load_image
        return nil unless Option.image_manager
        Marshal.load(pack(Zlib::Inflate.inflate(pack(Option.image_manager)))).reverse
      end

      def self.column(params)
        params[:target] == "noimage" ? "image_manager_#{params[:target]}=" : "image_manager_#{params[:target]}_#{params[:id]}="
      end

      def self.get_class(service)
        eval(service.to_s.capitalize)
      end

      def self.unpack(obj)
        obj.unpack("H*").first
      end

      def self.pack(obj)
        [obj].pack("H*")
      end
    end
  end
end
