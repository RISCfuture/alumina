module Alumina
  
  # Each of the elements has a singleton instance of this class. You do not
  # create instances of this class; they are loaded from a data file.
  
  class Element
    # @return [Fixnum] The element's atomic number (hydrogen is 1).
    attr_reader :atomic_number
    # @return [String] The element's name.
    attr_reader :name
    # @return [String] The element's symbol (hydrogen is @H@).
    attr_reader :symbol
    
    # @private
    def initialize(atomic_number, name, symbol)
      @atomic_number = atomic_number
      @name = name
      @symbol = symbol
    end
    
    # Provides a natural ordering based on atomic number.
    #
    # @param [Element] other The other element to compare against.
    # @return [-1, 0, 1] The sort equivalency.
    
    def <=>(other)
      atomic_number <=> other.atomic_number
    end
  end
end
