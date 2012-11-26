module DataStructures
  class TreeNode
    attr_reader :value, :left, :right
    attr_accessor :parent

    def initialize(value)
      raise NilNodeException if value.nil?
      @value = value
    end

    # Returns a string with a human-readable representation of the node
    def inspect
      "#<DataStructures::TreeNode value:#{value.inspect}>"
    end
    alias :to_s :inspect

    # Returns the root of the tree that the node belongs to
    def root
      root? ? self : self.parent.root
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

    # Removes self from the tree structure that it's a part of.
    # Returns the root of the new tree
    def remove_from_tree
      self.root? ? remove_root_from_tree : remove_child_from_tree
    end

    # Removes the branch starting with child (if such a branch exists)
    def remove_child(child)
      replace_child(child, nil)
    end

    # Replaces the branch starting with child with the replacement node
    # Returns the replacement node.
    def replace_child(child, replacement)
      if branches.include?(child)
        replacement.parent = self if replacement
        child.parent = nil
        if left == child
          @left = replacement
        else
          @right = replacement
        end
      end
    end

    # Returns the node containing the value, or nil if none exists
    def search_for(value)
      if self.value == value
        self
      elsif value < self.value && left
        left.search_for(value)
      elsif value > self.value && right
        right.search_for(value)
      end
    end

    # Recursively calls traverse on left, then yields self, then on right nodes
    # Traverses the nodes in sorted order
    def traverse
      if left
        left.traverse do |node|
          yield node
        end
      end
      yield self
      if right
        right.traverse do |node|
          yield node
        end
      end
    end

    # Yields self, then recursively calls traverse on left and right ndoes
    # Traverses the nodes in the order in which they were added
    def root_traverse
      yield self
      [left, right].compact.each do |branch|
        branch.root_traverse do |node|
          yield node
        end
      end
    end

    # Returns the minimum node under self
    def min
      # Starting to the right of this node, look only to the
      if left
        left.min
      else
        self
      end
    end

    # True if this node has neither left nor right branches
    def leaf?
      left.nil? && right.nil?
    end

    # True if this node has no parent
    def root?
      parent.nil?
    end

    # Returns an array of child branches (0, 1 or 2)
    def branches
      [left, right].compact
    end

  protected
    # Adds the node to the left branch
    def add_left(node)
      if left.nil?
        node.parent = self
        @left = node
      else
        left.add(node)
      end
    end

    # Adds a node to the right branch
    def add_right(node)
      if right.nil?
        node.parent = self
        @right = node
      else
        right.add(node)
      end
    end

    # Removes self from tree, given self is the root
    def remove_root_from_tree
      if self.root?
        if leaf?
          # Just return nil, and that will replace the root in the tree
          nil
        elsif branches.length == 1
          # Make the one branch be the new root
          new_root = branches.first
          new_root.parent = nil
          @left = nil
          @right = nil
          new_root
        else
          remove_two_branch_node
        end
      else
        remove_child_from_tree
      end
    end

    # Removes self from tree, given self is not the root
    def remove_child_from_tree
      if self.root?
        remove_root_from_tree
      else
        new_root = root # No change in root, so set this aside to return
        if leaf?
          # If we're a leaf, just remove this from its parent
          parent.remove_child(self)
        elsif branches.length == 1
          # If we have one child, remove this from its parent and replace the parent's branch with its child
          parent.replace_child(self, branches.first)
        else
          remove_two_branch_node
        end
        new_root
      end
    end

    # Removes self's value from tree.
    # NOTE: Doesn't actually remove self, just replaces self's value.
    def remove_two_branch_node
      # If we have two children: Call the node to be deleted N. Do not delete N. Instead, choose
      # its in-order successor node, R. Replace the value of N with the value of R, then delete R.
      successor = right.min
      @value = successor.value
      successor.remove_from_tree
    end
  end
end