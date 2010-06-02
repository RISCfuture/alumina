module Alumina
  module HIN
  
    # Class that parses HIN files to produce {Molecule} instances. This class is
    # not thread-safe! You must instantiate a new parser for each thread of your
    # program.
  
    class Parser
      # If @true@, does not raise {ParseError} when unknown commands are
      # encountered.
      attr_accessor :ignore_unknown_commands
    
      # Parses HIN data and returns an array of {Molecule Molecules}.
      #
      # @param [IO, String] input The HIN data to parse.
      # @return [Array<Alumina::Molecule>] The molecules described by the data.
      # @raise [ParseError] If the HIN data is improperly formatted.
    
      def parse(input)
        @molecules = Array.new
        @current_molecule = nil
        @line_counter = 0

        input.each_line do |line|
          @line_counter += 1
          next if line =~ /^\s*$/
          parts = line.split(/\s+/)

          command = parts.shift
          method = :"parse_#{command}"
          if respond_to?(method) then
            send(method, *parts)
          else
            if ignore_unknown_commands then
              raise ParseError.new(@line_counter, "Unknown command #{command}")
            else
              next
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
        raise ParseError.new(@line_counter, "Given endmol with id #{@id}, but open molecule has ID #{@current_molecule.id}") unless id.to_i == @current_molecule.id
      
        @molecules << @current_molecule
        @current_molecule = nil
      end

      # @private
      def parse_atom(id, label, symbol, ignored1, ignored2, unknown1, x, y, z, atomic_number, *structure)
        if @current_molecule then
          label = nil if label.blank?
          element = ELEMENTS_BY_SYMBOL[symbol] || ELEMENTS_BY_NUMBER[atomic_number.to_i]
          raise ParseError.new("Unknown element #{symbol}") unless element
        
          begin
            atom = Atom.new(id.to_i, element, x.to_f, y.to_f, z.to_f)
          rescue ArgumentError
            raise ParseError.new(@line_counter, $!.to_s) # catch bad orbitals
          end
        
          atom.label = label
          structure.in_groups_of(2).each { |(shell, shape)| atom.add_orbital(shell.to_i, shape) }
          @current_molecule << atom
        else
          raise ParseError.new(@line_counter, "Can't have an atom command outside of a mol section")
        end
      end
    end
  end
end
