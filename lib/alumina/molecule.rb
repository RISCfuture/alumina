module Alumina
  
  # A molecule as represented by HIN data, consisting of multiple {Atom Atoms}.
  
  class Molecule
    include Alumina::HIN::Writer::Molecule
    
    # @return [Fixnum] The unique numerical identifier for this molecule.
    attr_accessor :id
    # @return [String, nil] The optional label given to this molecule.
    attr_accessor :label
    
    # Creates a new instance.
    #
    # @param [Fixnum] id The molecule's unique ID. Uniqueness is not checked in
    # this method.
    # @param [String] label A label to give the molecule.
    
    def initialize(id, label=nil)
      @id = id
      @label = label
      @atoms = Hash.new
    end
    
    # Adds an atom to this molecule. If there is already an atom in this
    # molecule sharing this atom's {Atom#id ID}, it will be replaced by this
    # atom.
    #
    # @param [Atom] atom The atom to add.
    
    def <<(atom)
      @atoms[atom.id] = atom
    end
    
    # @return [Array<Atom>] An array of atoms in this molecule.
    
    def atoms
      @atoms.values
    end
    
    # Returns an atom for a given unique identifier.
    #
    # @param [Fixnum] ident The identifier to search.
    # @return [Atom, nil] The atom with that identifier, or @nil@ if no such
    # atom was found.
    
    def atom(ident)
      @atoms[ident]
    end
    
    alias :[] :atom
    
    # @return [String] Returns the plain-text molecular formula for this atom;
    # for example, @C7H5N3O6@ for TNT.
    
    def molecular_formula
      counts = atoms.map(&:element).inject(Hash.new(0)) { |hsh, cur| hsh[cur] += 1 ; hsh }
      counts.keys.sort.reverse.map { |element| "#{element.symbol}#{num_for counts[element]}" }.join
    end
    
    # @private
    def inspect
      if label then
        "#<Molecule ##{id} (#{label}): #{molecular_formula}>"
      else
        "#<Molecule ##{id}: #{molecular_formula}>"
      end
    end
    
    private
    
    def num_for(num)
      num.to_s.chars.map do |char|
        case char
          when '0' then ?\u2080
          when '1' then ?\u2081
          when '2' then ?\u2082
          when '3' then ?\u2083
          when '4' then ?\u2084
          when '5' then ?\u2085
          when '6' then ?\u2086
          when '7' then ?\u2087
          when '8' then ?\u2088
          when '9' then ?\u2089
        end
      end.join
    end
  end
end
