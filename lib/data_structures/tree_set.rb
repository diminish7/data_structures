require 'tree_node'

module DataStructures
  # Set implementation using a binary tree
  class TreeSet
    include Enumerable

    attr_reader :root, :length
    alias :count :length
    alias :size :length

    # Creates a new TreeSet containing the given objects
    def self.[](*values)
      self.new(*values)
    end

    # Initializes the set with the given values
    def initialize(*values)
      @length = 0
      values.each do |value|
        add(value)
      end
    end

    # Creates a new set with the same values as self
    def clone
      new_set = TreeSet.new
      # Create new nodes in the same order as self's
      if root
        root.root_traverse do |node|
          new_set << node.value
        end
      end
      new_set
    end
    alias :dup :clone

    # Returns a string with a human-readable representation of the node.
    def inspect
      "#<DataStructures::TreeSet {#{self.map { |val| val.inspect }.join(',')}}>"
    end
    alias :to_s :inspect

    def ==(other)
      if equal?(other)
        true
      elsif other.kind_of?(TreeSet) && other.length == self.length
        other.all? { |val| include?(val) }
      else
        false
      end
    end

    # Adds the value into the set. Returns self if the object is added, and nil if it was already in there
    def add?(value)
      node = TreeNode.new(value)
      added = if root.nil?
        @root = node
      else
        @root.add(node)
      end
      if added
        @length += 1
        self
      else
        nil
      end
    end

    # Adds the value into the set if it isnt there already. Returns self. Aliased as <<
    def add(value)
      add?(value) || self
    end
    alias :<< :add

    # Returns true if nothing has been added to the set yet
    def empty?
      root.nil?
    end

    # Empties the set
    def clear
      @root = nil
      @length = 0
      self
    end

    def delete(value)
      delete?(value) || self
    end

    def delete?(value)
      if root && node_to_delete = root.search_for(value)
        @root = node_to_delete.remove_from_tree
        @length -= 1
        self
      end
    end

    def subtract(enum)
      enum.each do |val|
        delete(val)
      end
      self
    end

    # Returns true if the set contains the value, and false if not
    def include?(value)
      return false if root.nil?
      !!root.search_for(value)
    end
    alias :member? :include?

    # Returns true if the set is a subset of the given set
    def subset?(set)
      set.all? { |val| self.include?(val) }
    end

    # Returns true if the set is a superset of the given set
    def superset?(set)
      self.all? { |val| set.include?(val) }
    end

    # Iterates over the set, yielding each value
    def each
      return [] if root.nil?
      root.traverse do |node|
        yield node.value
      end
    end

    # Merges the elements of the given enumerable object to the set and returns self
    def merge(enum)
      enum.each do |val|
        self << val
      end
      self
    end

    # Returns a new set containing elements common to this set and the given enum
    def &(enum)
      new_set = TreeSet.new
      enum.each do |val|
        new_set << val if self.include?(val)
      end
      new_set
    end
    alias :intersection :&

    # Returns a new set built by merging the set and the elements of the given enumerable object
    def |(enum)
      new_set = TreeSet.new
      [self, enum].each do |enumerable|
        enumerable.each do |val|
          new_set << val
        end
      end
      new_set
    end
    alias :+ :|
    alias :union :|

    # Returns a new set built by duplicating the set, removing every element that appears in the given enumerable object
    def -(enum)
      new_set = self.clone
      enum.each do |val|
        new_set.delete(val)
      end
      new_set
    end
    alias :difference :-

    # Returns a new set containing elements exclusive between the set and the given enumerable object.
    # (set ^ enum) is equivalent to ((set | enum) - (set & enum)).
    def ^(enum)
      ((self | enum) - (self & enum))
    end
  end
end