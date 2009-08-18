module SprocketsApplication
  class << self
    def routes(map)
      map.resources(:sprockets)
    end
    
    def source(namespace = nil)
      @namespace = namespace
      concatenation.to_s
    end
    
    def install_script
      concatenation.save_to(asset_path)
    end
    
    def install_assets
      secretary.install_assets
    end

    protected
      def secretary
        @secretary ||= Sprockets::Secretary.new(configuration.merge(:root => RAILS_ROOT))
      end
    
      def configuration
        @config = YAML.load(IO.read(File.join(RAILS_ROOT, "config", "sprockets.yml"))) || {}
        
        if @namespace
          @config[:source_files] = @config[:source_files][@namespace.to_sym]
        else
          @config[:source_files] = @config[:source_files][:default]
        end
        
        @config
      end

      def concatenation
        secretary.reset! unless source_is_unchanged?
        secretary.concatenation
      end

      def asset_path
        return File.join(Rails.public_path, "sprockets/#{@namespace}.js") if @namespace
        File.join(Rails.public_path, "sprockets.js")
      end

      def source_is_unchanged?
        return false
        previous_source_last_modified, @source_last_modified = 
          @source_last_modified, secretary.source_last_modified
          
        previous_source_last_modified == @source_last_modified
      end
  end
end
