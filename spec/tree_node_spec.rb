require 'spec_helper'
require 'tree_node'

include DataStructures

describe TreeNode do

  describe "#initialize(value)" do
    it "should raise an exception if the value is nil" do
      lambda { TreeNode.new(nil) }.should raise_exception(NilNodeException)
    end

    it "should set the initialize the value" do
      TreeNode.new(5).value.should == 5
    end

    it "should not set the branches" do
      node = TreeNode.new(5)
      node.left.should be_nil
      node.right.should be_nil
    end
  end

  describe "#inspect" do
    it "should return a human-readable representation of the node" do
      node = TreeNode.new(5)
      node.inspect.should == "#<DataStructures::TreeNode value:5>"
    end
  end

  describe "#to_s" do
    it "should return a human-readable representation of the node" do
      node = TreeNode.new(5)
      node.to_s.should == "#<DataStructures::TreeNode value:5>"
    end
  end

  describe "#add(node)" do
    let(:node) { TreeNode.new(5) }
    let(:lesser_node) { TreeNode.new(3) }
    let(:even_lesser_node) { TreeNode.new(1) }
    let(:greater_node) { TreeNode.new(8) }
    let(:even_greater_node) { TreeNode.new(9) }
    let(:eq_node) { TreeNode.new(5) }

    it "should create the left branch if the value is less" do
      node.left.should be_nil
      node.add(lesser_node).should == lesser_node
      node.left.should == lesser_node
    end

    it "should create the right branch if the value is greater" do
      node.right.should be_nil
      node.add(greater_node).should == greater_node
      node.right.should == greater_node
    end

    it "should do nothing if the values are equal" do
      node.add(eq_node).should be_nil
      node.left.should be_nil
      node.right.should be_nil
    end

    it "should add to the left branch if the value is less and the left branch exists" do
      node.add(lesser_node)
      node.add(even_lesser_node).should == even_lesser_node
      node.left.left.should == even_lesser_node
    end

    it "should add to the right branch if the value is greater and the right branch exists" do
      node.add(greater_node)
      node.add(even_greater_node).should == even_greater_node
      node.right.right.should == even_greater_node
    end

    it "should maintain the parent of each node" do
      node.add(lesser_node)
      node.add(even_lesser_node)
      node.add(greater_node)
      node.add(even_greater_node)

      node.parent.should be_nil
      lesser_node.parent.should == node
      greater_node.parent.should == node
      even_lesser_node.parent.should == lesser_node
      even_greater_node.parent.should == greater_node
    end
  end

  describe "#remove_child(child)" do
    #           5
    #          / \
    #         3   8
    let!(:root) { TreeNode.new(5) }
    let!(:left) { root.add(TreeNode.new(3)) }
    let!(:right) { root.add(TreeNode.new(8)) }

    it "should set the left branch to nil if it matches the child" do
      root.remove_child(left)
      root.left.should be_nil
      root.right.should_not be_nil
    end

    it "should set the right branch to nil if it matches the child" do
      root.remove_child(right)
      root.right.should be_nil
      root.left.should_not be_nil
    end

    it "should do nothing if the child isn't the root of either branch" do
      root.remove_child(TreeNode.new(9))
      root.right.should_not be_nil
      root.left.should_not be_nil
    end
  end

  describe "#replace_child(child, replacement)" do
    #           5
    #          / \
    #         3   8
    let!(:root) { TreeNode.new(5) }
    let!(:left) { root.add(TreeNode.new(3)) }
    let!(:right) { root.add(TreeNode.new(8)) }

    let(:left_replacement) { TreeNode.new(4) }
    let(:right_replacement) { TreeNode.new(7) }

    it "should replace the left branch" do
      root.replace_child(left, left_replacement)
      root.left.should == left_replacement
      left_replacement.parent.should == root
      left.parent.should be_nil
    end

    it "should replace the right branch" do
      root.replace_child(right, right_replacement)
      root.right.should == right_replacement
      right_replacement.parent.should == root
      right.parent.should be_nil
    end

    it "should replace nothing if the child isn't the root of either branch" do
      root.replace_child(right_replacement, left_replacement)
      root.left.should == left
      root.right.should == right
      left_replacement.parent.should be_nil
      right_replacement.parent.should be_nil
    end
  end

  describe "#remove_from_tree" do
    #           5
    #          / \
    #         3   8
    let(:root) { TreeNode.new(5) }
    let(:left) { root.add(TreeNode.new(3)) }
    let(:right) { root.add(TreeNode.new(8)) }

    describe "with a root node" do
      describe "that is the only node in the tree" do
        it "should return nil" do
          root.remove_from_tree.should be_nil
        end
      end

      describe "that has only one child branch" do
        it "should set its branches to nil and return the one child" do
          left
          new_root = root.remove_from_tree
          new_root.should == left
          root.left.should be_nil
          root.right.should be_nil
        end
      end

      describe "that has two branches" do
        it "should take on the value of the left branch node and delete the left branch node" do
          left
          right
          new_root = root.remove_from_tree
          root.value.should == right.value
          new_root.should == root
          new_root.right.should be_nil
        end
      end
    end

    describe "with a non-root node" do
      #           5
      #          / \
      #         3   8
      #        / \
      #       2   4
      before do
        left
        right
      end
      let(:left_left) { root.add(TreeNode.new(2)) }
      let(:left_right) { root.add(TreeNode.new(4)) }

      describe "that has no child branches" do
        it "should remove itself from its parent and return the root" do
          new_root = left.remove_from_tree
          new_root.should == root
          root.left.should be_nil
          left.parent.should be_nil
        end
      end

      describe "that has one child" do
        it "should replace itself with its child and return the root" do
          left_right
          new_root = left.remove_from_tree
          new_root.should == root
          root.left.should == left_right
          left_right.branches.should be_empty
          left.parent.should be_nil
        end
      end

      describe "that has two child branches" do
        it "should take on the value of the left branch node and delete the left branch node" do
          left_left
          left_right
          new_root = left.remove_from_tree
          new_root.should == root
          root.left.should == left
          left.value.should == left_right.value
          left.parent.should == root
          left.right.should be_nil
          left_right.parent.should be_nil
        end
      end
    end
  end

  describe "#root" do
    #           5
    #          / \
    #         3   8
    let!(:root) { TreeNode.new(5) }
    let!(:left) { root.add(TreeNode.new(3)) }
    let!(:right) { root.add(TreeNode.new(8)) }


    it "should return self if it is a root" do
      root.root.should == root
    end

    it "should return the root of the tree if it is not the root" do
      left.root.should == root
      right.root.should == root
    end
  end

  describe "#leaf?" do
    #           5
    #          / \
    #         3   8
    let(:root) { TreeNode.new(5) }
    let(:left) { root.add(TreeNode.new(3)) }
    let(:right) { root.add(TreeNode.new(8)) }

    it "should return true if the node has no right or left branches" do
      left.should be_leaf
      right.should be_leaf
    end

    it "should return false if the node has a right branch" do
      right
      root.should_not be_leaf
    end

    it "should return false if the node has a left branch" do
      left
      root.should_not be_leaf
    end

    it "should return false if the node has a right and left branch" do
      left
      right
      root.should_not be_leaf
    end
  end

  describe "#root?" do
    #           5
    #          / \
    #         3   8
    let!(:root) { TreeNode.new(5) }
    let!(:left) { root.add(TreeNode.new(3)) }
    let!(:right) { root.add(TreeNode.new(8)) }

    it "should return true if the node has no parent" do
      root.should be_root
    end

    it "should return false if the node has a parent" do
      left.should_not be_root
      right.should_not be_root
    end
  end

  describe "#search_for(value)" do
    #           5
    #          / \
    #         3   8
    let(:root) { TreeNode.new(5) }
    let(:left) { root.add(TreeNode.new(3)) }
    let(:right) { root.add(TreeNode.new(8)) }

    it "should return self if the value matches" do
      root.search_for(root.value).should == root
    end

    it "should find a node in the left branch" do
      root.search_for(left.value).should == left
    end

    it "should find a node in the right branch" do
      root.search_for(right.value).should == right
    end

    it "should find a node two-levels deep" do
      val = 4
      leaf = root.add(TreeNode.new(val))
      root.search_for(val).should == leaf
    end

    it "should return nil if the value isn't included in the tree" do
      root.search_for(1000).should be_nil
    end
  end

  describe "#traverse" do
    #           5
    #          / \
    #         3   8
    #        / \   \
    #       2   4   9
    let(:root) { TreeNode.new(5) }
    let(:left) { root.add(TreeNode.new(3)) }
    let(:right) { root.add(TreeNode.new(8)) }
    let(:left_left) { root.add(TreeNode.new(2)) }
    let(:right_right) { root.add(TreeNode.new(9)) }
    let(:left_right) { root.add(TreeNode.new(4)) }

    it "should yield self only if it has no branches" do
      counter = 0
      left_right.traverse do |node|
        node.should == left_right
        counter += 1
      end
      counter.should == 1
    end

    it "should yield the nodes to its left, then self, then to its right" do
      expectation = [left_left, left, left_right, root, right, right_right]
      index = 0
      root.traverse do |node|
        node.should == expectation[index]
        index += 1
      end
      index.should == expectation.length
    end
  end

  describe "#root_traverse" do
    #           5
    #          / \
    #         3   8
    #        / \   \
    #       2   4   9
    let(:root) { TreeNode.new(5) }
    let(:left) { root.add(TreeNode.new(3)) }
    let(:right) { root.add(TreeNode.new(8)) }
    let(:left_left) { root.add(TreeNode.new(2)) }
    let(:right_right) { root.add(TreeNode.new(9)) }
    let(:left_right) { root.add(TreeNode.new(4)) }

    it "should yield self only if it has no branches" do
      counter = 0
      left_right.root_traverse do |node|
        node.should == left_right
        counter += 1
      end
      counter.should == 1
    end

    it "should yeild self, then the nodes to its left, then to its right" do
      expectation = [root, left, left_left, left_right, right, right_right]
      index = 0
      root.root_traverse do |node|
        node.should == expectation[index]
        index += 1
      end
      index.should == expectation.length
    end

  end

  describe "#min" do
    #           5
    #          / \
    #         3   8
    #        / \   \
    #       2   4   9
    let!(:root) { TreeNode.new(5) }
    let!(:left) { root.add(TreeNode.new(3)) }
    let!(:right) { root.add(TreeNode.new(8)) }
    let!(:left_left) { root.add(TreeNode.new(2)) }
    let!(:right_right) { root.add(TreeNode.new(9)) }
    let!(:left_right) { root.add(TreeNode.new(4)) }

    it "should return self if there are no smaller numbers under self" do
      [left_left, left_right, right, right_right].each do |node|
        node.min.should == node
      end
    end

    it "should return the smallest node under self if smaller nodes exist" do
      left.min.should == left_left
      root.min.should == left_left
    end
  end

end