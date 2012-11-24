module DataStructures
  class TreeNode
    attr_reader :value, :left, :right

    def initialize(value)
      raise NilNodeException if value.nil?
      @value = value
    end

    # Adds the node to its left branch if its value is less than this node's value.
    # Adds the node to its right branch if its value is greater than this node's value.
    # Otherwise does nothing (since the values are equal, and so this shouldn't be added)
    def add(node)
      if node.value < value
        add_left(node)
      elsif node.value > value
        add_right(node)
      end
    end

  protected
    def add_left(node)
      if left.nil?
        @left = node
      else
        left.add(node)
      end
    end

    def add_right(node)
      if right.nil?
        @right = node
      else
        right.add(node)
      end
    end
  end
end