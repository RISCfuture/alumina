module Alumina
  # A singleton instance of this class exists for each defined orbital among any
  # atom. Thus, if two atoms both have 1s orbitals, each of their
  # {Atom#structure} arrays will contain the same @Orbital@ instance
  # corresponding to the 1s orbital.
  #
  # Orbitals are automatically created as necessary; you do not initialize them.
  
  class Orbital
    # Valid orbital subshell names, ordered by their _l_-value.
    SHAPES = %w( s p d f g h i k l m n o p q r t u v w x y z )
    
    # @return [Fixnum] The principal quantum number or _n_ value; e.g., @2@ for
    # a 2p orbital.
    attr_reader :shell
    # @return [String] The azimuthal quantum number or _l_ value; e.g., @3@ for
    # a 4d orbital.
    attr_reader :subshell
    
    alias :n :shell
    alias :l :subshell
    
    # Returns or creates the @Orbital@ for a given shell and subshell.
    #
    # @param [Fixnum] shell The orbital shell (see {#shell}).
    # @param [Fixnum, String] subshell The orbital subshell (see {#subshell}).
    # @return [Orbital] The corresponding orbital instance.
    # @raise [ArgumentError] If an invalid shell or subshell is provided.
    
    def self.for(shell, subshell)
      original_subshell = subshell
      subshell = SHAPES.index(subshell) if subshell.kind_of?(String)
      raise ArgumentError, "Unknown orbital subshell #{original_subshell.inspect}" if subshell.nil?
      raise ArgumentError, "Invalid shell n=#{shell}" if shell < 1
      raise ArgumentError, "No l=#{subshell} subshell within an n=#{shell} shell" if subshell < 0 or subshell >= shell
      
      @@orbitals ||= Hash.new
      @@orbitals[shell] ||= Hash.new
      @@orbitals[shell][subshell] ||= Orbital.new(shell, subshell)
      @@orbitals[shell][subshell]
    end
    
    # @return [String] The letter symbol for the subshell (e.g., @p@ for an
    # _l_-value of 1), or the numerical value for the subshell if no letter
    # value exists (really really big atoms only).
    
    def subshell_name
      SHAPES[subshell] || subshell
    end
    
    # @private
    def initialize(shell, subshell)
      @shell = shell
      @subshell = subshell
    end
    
    # @private
    def inspect
      "#{shell}#{subshell}"
    end
  end
end
