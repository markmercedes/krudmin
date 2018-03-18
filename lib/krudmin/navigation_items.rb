module Krudmin
  class NavigationItems
    include Enumerable

    def initialize(items: nil)
      @items = items
    end

    def each(&block)
      visible_items.each(&block)
    end

    private

    def visible_items
      @visible_items ||= items.select(&:visible?)
    end

    def routes
      Rails.application.routes.url_helpers
    end

    def items
      @items ||= [
        Krudmin::NavigationItems::Node.new(:dashboard, Krudmin::Config.krudmin_root_path, icon: :tachometer),
      ].concat(Krudmin::Config.menu_items.call).compact
    end

    class Node
      include Enumerable

      attr_reader :label, :link, :label_class, :visible_if, :items, :icon, :module_path

      def initialize(label, link, visible_if: -> { true }, items: [], icon: :file, module_path: nil)
        @label = label
        @visible_if = visible_if
        @items = items
        @icon = icon
        @module_path = module_path

        @label_class = "menu-node-#{label}".parameterize

        @link = link.is_a?(Symbol) ? routes.send(link) : link
      end

      def visible?
        if items.any?
          visible_if.call && visible_items.any?
        else
          visible_if.call
        end
      end

      def each(&block)
        items.select{ |item| item.visible_if.call }.each(&block)
      end

      class << self
        def routes
          Rails.application.routes.url_helpers
        end

        def node_for(label, resource, visible_if: -> { true }, icon: :file, module_path: nil, manage_if: -> { true }, add_if: -> { true })
          new(label, "#", visible_if: visible_if, items: links_for(resource, module_path, manage_if: manage_if, add_if: add_if), icon: icon, module_path: module_path)
        end

        def links_for(resource, module_path = "", manage_if: -> { true }, add_if: -> { true })
          module_path = "#{module_path}_" if module_path.present?

          [
            new(I18n.t("krudmin.actions.manage"), routes.send("#{module_path}#{resource.pluralize}_path"), icon: :list, visible_if: manage_if),
            new(I18n.t("krudmin.actions.add_new"), routes.send("new_#{module_path}#{resource}_path"), icon: :plus, visible_if: add_if),
          ]
        end
      end

      private

      def visible_items
        @visible_items ||= items.select(&:visible?)
      end

      def routes
        Rails.application.routes.url_helpers
      end
    end
  end
end
