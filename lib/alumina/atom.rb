module Alumina
  
  # An atom as part of a {Molecule}.
  
  class Atom
    include Alumina::HIN::Writer::Atom
    
    BOND_TYPES = [ :single, :double, :triple, :aromatic ]
    
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
    # @return [Hash<Atom, Symbol>] The atoms this atom is bonded to, along with
    # the bond type.
    attr_accessor :bonds
    # @return [Fixnum] The partial charge.
    attr_accessor :partial_charge
    
    # @private
    attr_accessor :ignored1, :ignored2
    
    # Initializes a new atom. After initializing it you can define its bonds
    # strucrure using the {.bind} method. Atoms are added to
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
      @bonds = Hash.new
    end
    
    # Binds two atoms together.
    #
    # @param [Atom] atom1 An atom to bind.
    # @param [Atom] atom2 An atom to bind.
    # @param [Symbol] The bond type. (See {BOND_TYPES}.)
    # @raise [ArgumentError] If an invalid bond type is given.
    
    def self.bind(atom1, atom2, type)
      raise ArgumentError, "Invalid bond type #{type.inspect}" unless BOND_TYPES.include?(type)
      
      atom1.bonds[atom2] = type
      atom2.bonds[atom1] = type
    end
    
    # @return [Fixnum] The number of atoms bound to this atom.
    
    def bond_count
      bonds.size
    end
    
    # Creates a duplicate of this atom with no bonds.
    #
    # @return [Atom] A duplicate of this atom.
    
    def dup
      atom = Atom.new(id, element, x, y, z)
      atom.label = label
      atom.partial_charge = partial_charge
      atom.ignored1 = ignored1
      atom.ignored2 = ignored2
      return atom
    end
    
    # @private
    def inspect
      if label then
        "#<Atom ##{id} #{label} (#{element.symbol})>"
      else
        "#<Atom ##{id} #{element.symbol}>"
      end
    end
  end
end
