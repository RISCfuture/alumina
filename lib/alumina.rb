require 'yaml'
require 'extensions'
require 'alumina/errors'
require 'alumina/element'
require 'alumina/orbital'
require 'alumina/atom'
require 'alumina/molecule'
require 'alumina/hin'
require 'alumina/hin/parser'

# Container module for classes of the Alumina gem.

module Alumina
  # An array of all {Element Elements}, loaded from a YAML data file.
  ELEMENTS = YAML.load(File.read('../data/elements.yml')).map { |atomic_number, data| Element.new(atomic_number, data[:name], data[:symbol]) }
  # All elements hashed by their symbol (e.g., "Ag" for silver).
  ELEMENTS_BY_SYMBOL = ELEMENTS.inject({}) { |hsh, cur| hsh[cur.symbol] = cur ; hsh }
  # All elements hashed by their atomic number.
  ELEMENTS_BY_NUMBER = ELEMENTS.inject({}) { |hsh, cur| hsh[cur.atomic_number] = cur ; hsh }
  
  # Creates a {HIN::Parser} and calls {HIN::Parser#parse} on it.
  #
  # @param [IO, String] input The HIN data to parse.
  # @return [Array<Alumina::Molecule>] The molecules described by the data.
  # @raise [ParseError] If the HIN data is improperly formatted.
  
  def self.HIN(input)
    Alumina::HIN::Parser.new.parse(input)
  end
end
