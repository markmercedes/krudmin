module Krudmin
  class SearchForm
    module SearchPhrasesSupport
      class SearchTranslation
        attr_reader :str
        def initialize(str)
          @str = str
        end

        def to_s
          I18n.t("krudmin.search.#{@str}")
        end

        def join_phrase
          I18n.t("krudmin.search.join_phrases.#{@str}")
        end
      end

      def self.translation_for(key)
        SearchTranslation.new(key)
      end

      SEARCH_PREDICATES = {
        translation_for(:contains) => :cont,
        translation_for(:equals) => :eq,
        translation_for(:not_equal_to) => :not_eq,
        translation_for(:matches) => :matches,
        translation_for(:doesnt_match) => :does_not_match,
        translation_for(:less_than) => :lt,
        translation_for(:less_than_or_equal_to) => :lteq,
        translation_for(:greater_than) => :gt,
        translation_for(:greater_than_or_equal_to) => :gteq,
        translation_for(:doesnt_contain) => :not_cont,
        translation_for(:starts_with) => :start,
        translation_for(:doesnt_start_with) => :not_start,
        translation_for(:ends_with) => :end,
        translation_for(:doesnt_end_with) => :not_end,
        translation_for(:yes) => :true,
        translation_for(:no) => :false
      }.freeze

      def search_predicates_for(field)
        input_type_for(field)::SEARCH_PREDICATES.map{|type| SEARCH_PREDICATES.find{|label, key| type == key}}
      end

      def search_phrase_for(field)
        SEARCH_PREDICATES.find{|pre| pre.last == search_criteria["#{field}_options"].to_sym }.first.join_phrase
      end
    end
  end
end
