module Alumina
  
  # Raised when invalid HIN data is encountered.
  
  class ParseError < StandardError
    # @return [Fixnum] The line in the HIN data at which the error occurred.
    attr_accessor :line
    
    # @private
    def initialize(line, reason)
      @line = line
      super(reason)
    end
  end
end
