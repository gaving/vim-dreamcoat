module Dreamcoat::ENV

  class << self
    def [] key
      self.send key
    end

    def directory
      @directory = Vim.evaluate 'g:DREAMCOAT_DIRECTORY'
    end

    def scheme_registry
      @scheme_registry  ||= Vim.evaluate 'g:DREAMCOAT_SCHEME_REGISTRY'
    end

    def schemes_path
      @schemes_path ||= File.join(directory, "schemes")
    end

    def install_path
      @install_path  ||= Vim.evaluate 'g:DREAMCOAT_INSTALL_PATH'
    end

    def silence_warnings?
      Vim.evaluate('g:DREAMCOAT_SILENCE_WARNINGS') == 1
    end
  end

end
