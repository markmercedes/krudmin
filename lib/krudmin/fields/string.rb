module Krudmin
  module Fields
    class String < Base
      SEARCH_PREDICATES = [:cont, :eq, :matches, :does_not_match, :start, :not_start, :end, :not_end]
    end
  end
end
