module Alumina
  module HIN
  
    # Class that parses HIN files to produce {Molecule} instances. This class is
    # not thread-safe! You must instantiate a new parser for each thread of your
    # program.
  
    class Parser
      # Mapping of HIN file bond types to their symbol values for the {Atom}
      # class.
      BOND_TYPES = {
        's' => :single,
        'd' => :double,
        't' => :triple,
        'a' => :aromatic
      }
      
      # If @true@, does not raise {ParseError} when
      #
      # * unknown commands are encountered,
      # * the bond count is incorrect, or
      # * an @endmol@'s ID does not correspond to its @mol@'s ID.
      attr_accessor :lenient
    
      # Parses HIN data and returns an array of {Molecule Molecules}.
      #
      # @param [IO, String] input The HIN data to parse.
      # @return [Array<Alumina::Molecule>] The molecules described by the data.
      # @raise [ParseError] If the HIN data is improperly formatted.
    
      def parse(input)
        @molecules = Array.new
        @current_molecule = nil
        @line_counter = 0
        @bonds = Hash.autonew

        input.each_line do |line|
          @line_counter += 1
          next if line =~ /^\s*$/
          next if line[0] == ';' # comment
          parts = line.split(/\s+/)

          command = parts.shift
          method = :"parse_#{command}"
          if respond_to?(method) then
            send(method, *parts)
          else
            if lenient then
              next
            else
              raise ParseError.new(@line_counter, "Unknown command #{command}")
            end
          end
        end
        
        @bonds.each do |molecule, firsts|
          firsts.each do |atom1, lasts|
            lasts.each do |atom2, bond_type|
              Atom.bind molecule[atom1], molecule[atom2], BOND_TYPES[bond_type]
            end
          end
        end

        return @molecules
      end
    
      protected
    
      def parse_forcefield(*unknowns)
        #TODO
      end
    
      def parse_sys(*unknowns)
        #TODO
      end
    
      def parse_view(*unknowns)
        #TODO
      end
    
      def parse_box(*unknowns)
        #TODO
      end
      
      def parse_seed(*unknowns)
        #TODO
      end
    
      # @private
      def parse_mol(id, label=nil)
        if @current_molecule then
          raise ParseError.new(@line_counter, "Can't have a mol section within another mol section")
        else
          label = nil if label.blank?
          @current_molecule = Molecule.new(id.to_i, label)
        end
      end
    
      # @private
      def parse_endmol(id)
        raise ParseError.new(@line_counter, "Given endmol with id #{@id}, but open molecule has ID #{@current_molecule.id}") if id.to_i != @current_molecule.id and not lenient
      
        @molecules << @current_molecule
        @current_molecule = nil
      end

      # @private
      def parse_atom(id, label, symbol, ignored1, ignored2, partial_charge, x, y, z, bond_count, *bonds)
        if @current_molecule then
          label = nil if label.blank?
          element = ELEMENTS_BY_SYMBOL[symbol]
          raise ParseError.new("Unknown element #{symbol}") unless element
        
          atom = Atom.new(id.to_i, element, x.to_f, y.to_f, z.to_f)
          atom.label = label
          atom.ignored1 = ignored1
          atom.ignored2 = ignored2
          atom.partial_charge = partial_charge.to_i
          
          bond_count = bond_count.to_i
          raise ParseError.new(@line_counter, "Expected #{bond_count} bonds but found #{bonds.size/2}") if bond_count != bonds.size/2 and not lenient
          
          bonds.in_groups_of(2).each do |(atom_id, bond_type)|
            first_id = [ atom.id, atom_id.to_i ].min
            last_id = [ atom.id, atom_id.to_i ].max
            if @bonds[@current_molecule][first_id][last_id] != {} and @bonds[@current_molecule][first_id][last_id] != bond_type then
              raise ParseError.new(@line_counter, "Assymetric bond between #{first_id} and #{last_id} of type #{bond_type}")
            end
            raise ParseError.new(@line_counter, "Unknown bond type #{bond_type}") unless BOND_TYPES.include?(bond_type)
            @bonds[@current_molecule][first_id][last_id] = bond_type
          end
          @current_molecule << atom
        else
          raise ParseError.new(@line_counter, "Can't have an atom command outside of a mol section")
        end
      end
    end
  end
end
