module Alumina
  module HIN
    
    # Modules that add methods for writing data in HIN format.
    
    module Writer
      
      # Adds methods for writing data in HIN format to {Molecule} objects.
      
      module Molecule
        
        # Outputs this molecule in HIN format.
        
        def to_hin
          lines = atoms.map(&:to_hin)
          lines.unshift "mol #{id}#{" #{label}" if label}"
          lines.push "endmol #{id}"
          lines.join("\n")
        end
      end
      
      # Adds methods for writing data in HIN format to {Atom} objects.
      
      module Atom
        
        # Outputs this atom in HIN format.
        
        def to_hin
          "atom #{id} #{label || '-'} #{element.symbol} #{ignored1} #{ignored2} #{partial_charge} #{x} #{y} #{z} #{bonds.size} " + bonds.map { |atom, type| "#{atom.id} #{HIN::Parser::BOND_TYPES.key(type)}" }.join(' ')
        end
      end
    end
  end
end
