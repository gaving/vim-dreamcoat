module Dreamcoat

  class << self

    #
    # @return [Array<String>]
    #   List of dependencies required for Dreamcoat to boot.
    #
    def dependencies
      @dependencies ||=
      [
        "rubygems",
        "dreamcoat/env" ,
        "vim/improvedbuffer",
        "fileutils",
        "json",
        "open-uri",
        "uri",
        "zipruby"
      ]
    end

    #
    # @return [Boolean]
    #   Could dreamcoat load all its dependencies?
    #
    def dependencies_met?
      dependencies == met_dependencies
    end

    #
    # @return [Array<String>]
    #   A list of dependencies dreamcoat could load successfully.
    #
    def met_dependencies
      @met_depedencies ||= []
    end

    #
    # @return [Array<String>]
    #   A list of dependencies dreamcoat could load successfully.
    #
    def schemes
      @schemes ||= []
    end

    #
    # Loads all dependencies from {dependencies}.
    #
    # @return [void]
    #
    def load_dependencies!
      dependencies.each do |dependency|
        begin
          require(dependency)
        rescue LoadError
        else
          met_dependencies << dependency
        end
      end
    end

    def refresh_schemes!
      Vim.command "call pathogen#infect('#{Dreamcoat::ENV.schemes_path}')"
    end

    def load_schemes!
      return nil unless dependencies_met?

      glob = File.join(Dreamcoat::ENV.schemes_path, "**/*.vim")
      Dir[glob].each do |scheme|
          schemes << File.basename(scheme, '.*')
      end
    end

    def missing_dependencies
      dependencies - met_dependencies
    end

    def open_browser path
      browser_path = Shellwords.escape(Dreamcoat::ENV.browser)
      browser_args = Dreamcoat::ENV.browser_args
      file_path    = Shellwords.escape(path)

      Vim.command "silent ! #{browser_path} #{browser_args} #{file_path}"
      Vim.command "redraw!"
    end

    def extract_scheme url
      Zip::Archive.open_buffer(open(URI::join(url + '/', './zipball/master').to_s).read) do |ar|
        ar.each do |ar|
          path = File.join(Dreamcoat::ENV.schemes_path, ar.name)
          if ar.directory?
            FileUtils.mkdir_p(path)
          else
            dirname = File.dirname(path)
            FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

            open(path, 'wb') do |f|
              f << ar.read
            end
          end
        end
      end
    end

    def random!
      unless dependencies_met?
        msg = "Dreamcoat is missing dependenices: #{missing_dependencies.join(', ')}"
        Vim.message(msg)
        return nil
      end

      # NOTE: This is 'sample' in ruby 1.9
      Vim.command "colorscheme #{schemes.choice}"
    end

    def load! scheme
      unless dependencies_met?
        msg = "Dreamcoat is missing dependenices: #{missing_dependencies.join(', ')}"
        Vim.message(msg)
        return nil
      end

      result = JSON.parse(open("#{Dreamcoat::ENV.scheme_registry}/find/#{scheme}").read)
      Dreamcoat.extract_scheme(result['url']) if result['url']
      Dreamcoat.refresh_schemes!
      Vim.command "colorscheme #{scheme}"
    end

  end

end
