module Krudmin
  class NavigationItems
    include Enumerable

    attr_reader :user
    def initialize(user:, items: nil)
      @user = user
      @items = items
    end

    def each(&block)
      visible_items.each(&block)
    end

    private

    def visible_items
      items.select(&:visible)
    end

    def routes
      Rails.application.routes.url_helpers
    end

    def items
      @items ||= [
        build_node(:dashboard, routes.krudmin_path, icon: :tachometer),
        node_for("Cars", 'car', :car),
      ]
    end

    def node_for(label, resource, icon)
      build_node(label, "#", items: links_for(resource), icon: icon)
    end

    def links_for(resource)
      links = [
        build_node(I18n.t("krudmin.actions.manage"), routes.send("admin_#{resource.pluralize}_path"), icon: :list),
        build_node(I18n.t("krudmin.actions.add_new"), routes.send("new_admin_#{resource}_path"), icon: :plus),
      ]
    end

    def build_node(*args)
      Node.new(*args)
    end

    class Node
      include Enumerable

      attr_reader :label, :link, :visible, :items, :icon

      def initialize(label, link, visible: true, items: [], icon: :file)
        @label, @link, @visible, @items, @icon = label, link, visible, items, icon
      end

      def each(&block)
        items.select(&:visible).each(&block)
      end

      private

      def visible_items
        items.select(&:visible)
      end
    end
  end
end
