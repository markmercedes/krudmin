module Krudmin
  class NavigationMenu
    include Enumerable

    #TODO: Add caching layer on top in order to avoid so many proc calls over and over

    attr_reader :configuration
    def initialize(&block)
      @items = []
      @configuration = block
    end

    def for(user)
      configuration&.call(self, user)

      self
    end

    def self.configure(&block)
      new(&block)
    end

    def link(*args)
      items << Node.new(*args)
    end

    def node(*args)
      items << Node.node_for(*args)
    end

    def each(&block)
      visible_items.each(&block)
    end

    private

    attr_reader :items

    def visible_items
      @visible_items ||= items.select(&:visible?)
    end
  end
end
