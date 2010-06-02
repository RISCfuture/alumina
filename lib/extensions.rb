# @private
class String
  
  # @private
  def blank?
    self =~ /^\s*$/
  end
end

# @private
class NilClass
  
  # @private
  def blank?
    true
  end
end

# @private
class Array
  # @private -- Credit to DHH and the Rails team
  def in_groups_of(number, fill_with = nil)
    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat([fill_with] * padding)
    end
  
    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      returning [] do |groups|
        collection.each_slice(number) { |group| groups << group }
      end
    end
  end
end

# @private
class Object
  # @private -- Credit to DHH and the Rails team
  def returning(value)
    yield(value)
    value
  end
end

# @private
class Hash
  # @private -- credit to Trans, Jan Molic, Facets team
  def self.autonew(*args)
    leet = lambda { |hsh, key| hsh[key] = new( &leet ) }
    new(*args,&leet)
  end
end
