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
  end

end