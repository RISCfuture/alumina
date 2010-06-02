module Alumina
  
  # An atom as part of a {Molecule}.
  
  class Atom
    # @return [Fixnum] The unique numerical identifier assigned to the atom.
    attr_accessor :id
    # @return [String, nil] The optional label given to the atom.
    attr_accessor :label
    # @return [Element] The atomic type.
    attr_accessor :element
    # @return [Float] The atom's _x_-coordinate in the molecule.
    attr_accessor :x
    # @return [Float] The atom's _y_-coordinate in the molecule.
    attr_accessor :y
    # @return [Float] The atom's _z_-coordinate in the molecule.
    attr_accessor :z
    # @return [Array<Orbital>] The structure of electrons for this atom.
    attr_accessor :structure
    
    # Initializes a new atom. After initializing it you can define its orbital
    # strucrure using the {#add_orbital} method. Atoms are added to
    # {Molecule Molecules} with the @<<@ method.
    #
    # @param [Fixnum] id A unique identifier for this atom. Uniqueness is not
    # checked here.
    # @param [Element] element The atom's type.
    # @param [Float] x The atom's _x_-coordinate in the molecule.
    # @param [Float] y The atom's _y_-coordinate in the molecule.
    # @param [Float] z The atom's _z_-coordinate in the molecule.
    
    def initialize(id, element, x, y, z)
      @id = id
      @element = element
      @x = x
      @y = y
      @z = z
      @structure = Array.new
    end
    
    # Adds a new orbital to this atom.
    #
    # @overload add_orbital(orbital_string)
    #   @param [String] orbital_string A description of the orbital; e.g., @2s@.
    # @overload add_orbital(shell, subshell)
    #   @param [Fixnum] shell The orbital's layer; e.g., @1@ for a 1s orbital.
    #   @param [String, Fixnum] subshell The orbital's subshell; e.g., @p@ or
    #   @1@ for a 3p orbital.
    
    def add_orbital(orbital_string_or_shell, subshell=nil)
      shell = orbital_string_or_shell
      if subshell.nil? then
        matches = orbital_string_or_shell.match(/^(\d+)([spdfg])$/)
        shell = matches[1].to_i
        subshell = matches[2]
      end
      
      @structure << Orbital.for(shell, subshell)
    end
    
    # @private
    def inspect
      if label then
        "#<Atom ##{id} #{label} (#{element.symbol}): #{structure.inspect}>"
      else
        "#<Atom ##{id} #{element.symbol}: #{structure.inspect}>"
      end
    end
  end
end
