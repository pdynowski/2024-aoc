class Object
  def deep_dup
    duplicable? ? dup : self
  end
end

class Array
  def deep_dup
    map(&:deep_dup)
  end
end

class Hash
  # Returns a deep copy of hash.
  #
  #   hash = { a: { b: 'b' } }
  #   dup  = hash.deep_dup
  #   dup[:a][:c] = 'c'
  #
  #   hash[:a][:c] # => nil
  #   dup[:a][:c]  # => "c"
  def deep_dup
    hash = dup
    each_pair do |key, value|
      if ::String === key || ::Symbol === key
        hash[key] = value.deep_dup
      else
        hash.delete(key)
        hash[key.deep_dup] = value.deep_dup
      end
    end
    hash
  end
end

class Object
  # Can you safely dup this object?
  #
  # False for method objects;
  # true otherwise.
  def duplicable?
    true
  end
end

methods_are_duplicable = begin
  Object.instance_method(:duplicable?).dup
  true
rescue TypeError
  false
end

unless methods_are_duplicable
  class Method
    # Methods are not duplicable:
    #
    #   method(:puts).duplicable? # => false
    #   method(:puts).dup         # => TypeError: allocator undefined for Method
    def duplicable?
      false
    end
  end

  class UnboundMethod
    # Unbound methods are not duplicable:
    #
    #   method(:puts).unbind.duplicable? # => false
    #   method(:puts).unbind.dup         # => TypeError: allocator undefined for UnboundMethod
    def duplicable?
      false
    end
  end
end

require "singleton"

module Singleton
  # Singleton instances are not duplicable:
  #
  #   Class.new.include(Singleton).instance.dup # TypeError (can't dup instance of singleton
  def duplicable?
    false
  end
end

class Module
  # Returns a copy of module or class if it's anonymous. If it's
  # named, returns +self+.
  #
  #   Object.deep_dup == Object # => true
  #   klass = Class.new
  #   klass.deep_dup == klass # => false
  def deep_dup
    if name.nil?
      super
    else
      self
    end
  end
end