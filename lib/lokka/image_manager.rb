$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'zlib'
require 'image_manager/image'
require 'image_manager/base'
require 'image_manager/helper'
require 'image_manager/lib/picasa'

module Lokka
  module ImageManager
    EXTERNAL ||= [:picasa]

    def self.registered(app)
      app.get "/admin/plugins/image_manager" do
        unless ImageManager::Base.auth?
          redirect "/admin/plugins/image_manager/settings"
          return
        end
        if params[:order] == 'old'
          @images = ImageManager::Base.load_image.reverse
        else
          @images = ImageManager::Base.load_image
        end
        haml :"plugin/lokka-image_manager/views/index", :layout => :"admin/layout", :locals => { :services => EXTERNAL }
      end

      app.post "/admin/plugins/image_manager/upload" do
        if ImageManager::Base.upload(params)
          flash[:notice] = t('image_manager.flash.upload_success')
        else
          flash[:notice] = t('image_manager.flash.upload_fail')
        end
        redirect "/admin/plugins/image_manager"
      end

      app.get "/admin/plugins/image_manager/thumbnail" do
        @categories = Category.all.page(params[:page], :per_page => settings.admin_per_page)
        get_admin_entries(Post)
        haml :"plugin/lokka-image_manager/views/thumbnail", :layout => :"admin/layout", :locals => { :services => EXTERNAL }
      end

      app.post "/admin/plugins/image_manager/thumbnail" do
        if ImageManager::Base.thumbnail(params)
          flash[:notice] = t('image_manager.flash.upload_success')
        else
          flash[:notice] = t('image_manager.flash.upload_fail')
        end
        redirect "/admin/plugins/image_manager/thumbnail"
      end

      app.get "/admin/plugins/image_manager/settings" do
        haml :"plugin/lokka-image_manager/views/settings", :layout => :"admin/layout", :locals => { :services => EXTERNAL }
      end

      app.get "/admin/plugins/image_manager/settings/:service" do
        haml :"plugin/lokka-image_manager/views/settings/#{params[:service]}", :layout => :"admin/layout"
      end

      app.post "/admin/plugins/image_manager/settings/:service" do
        if ImageManager::Base.register(params)
          flash[:notice] = t('image_manager.flash.auth_success')
          redirect "/admin/plugins/image_manager"
          return
        end
        flash[:notice] = t('image_manager.flash.auth_fail')
        haml :"plugin/lokka-image_manager/views/settings/#{params[:service]}", :layout => :"admin/layout"
      end

      app.delete "/admin/plugins/image_manager/delete/:target/:id" do
        ImageManager::Base.delete(params)
        flash[:notice] = t('image_manager.flash.delete_success')
        redirect "/admin/plugins/image_manager"
      end
    end
  end
end

