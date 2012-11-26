require 'spec_helper'
require 'tree_set'

include DataStructures

describe TreeSet do

  describe "::[](*values)" do
    it "should initialize a new tree set with the given values" do
      set = TreeSet[5, 3, 8]
      set.root.value.should == 5
      set.root.left.value.should == 3
      set.root.right.value.should == 8
    end
  end

  describe "#initialize(*values)" do
    it "should intialize a new tree set with the given values" do
      set = TreeSet.new(5, 3, 8)
      set.root.value.should == 5
      set.root.left.value.should == 3
      set.root.right.value.should == 8
    end
  end

  describe "#clone" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 9, 4) }

    it "should return a new set with the same values but no matching nodes" do
      new_set = set.clone
      new_set.length.should == set.length

      root = set.root
      new_root = new_set.root

      # 5
      new_root.should_not == root
      new_root.value.should == root.value

      # 3
      new_root.left.should_not == root.left
      new_root.left.value.should == root.left.value

      # 8
      new_root.right.should_not == root.right
      new_root.right.value.should == root.right.value

      # 2
      new_root.left.left.should_not == root.left.left
      new_root.left.left.value.should == root.left.left.value

      # 4
      new_root.left.right.should_not == root.left.right
      new_root.left.right.value.should == root.left.right.value

      # 9
      new_root.right.right.should_not == root.right.right
      new_root.right.right.value.should == root.right.right.value
    end
  end

  describe "#inspect" do
    it "should return a human-readable representation of the set" do
      set = TreeSet.new(5, 3, 8)
      set.inspect.should == "#<DataStructures::TreeSet {3,5,8}>"
    end
  end

  describe "#to_s" do
    it "should return a human-readable representation of the set" do
      set = TreeSet.new(5, 3, 8)
      set.to_s.should == "#<DataStructures::TreeSet {3,5,8}>"
    end
  end

  describe "add(value)" do
    it "should set the root if the root hasn't been set" do
      set = TreeSet.new
      set.root.should be_nil
      set.add(5)
      set.root.value.should == 5
      set.length.should == 1
    end

    it "should add to the root if the root has been set" do
      set = TreeSet.new(5)
      set.root.value.should == 5
      set.add(3)
      set.root.left.value.should == 3
      set.length.should == 2
    end
  end

  describe "<<(value)" do
    it "should work like #add" do
      set = TreeSet.new
      set << 5
      set.root.value.should == 5
      set.length.should == 1
    end
  end

  describe "empty?" do
    it "should be true if nothing has been added to the set" do
      set = TreeSet.new
      set.should be_empty
    end

    it "should be false if something has been added to the set" do
      set = TreeSet.new(5)
      set.should_not be_empty
    end
  end

  describe "#clear" do
    it "should empty the set" do
      set = TreeSet.new(5, 3, 8)
      set.clear
      set.should be_empty
      set.length.should be_zero
    end
  end

  describe "#include?(value)" do
    let(:values) { [5, 3, 8] }
    let(:set) { TreeSet.new(*values) }

    it "should return true if the value is in the set" do
      values.each do |val|
        set.include?(val).should be_true
      end
    end

    it "should return false if the value is not in the set" do
      set.include?(10000).should be_false
    end
  end

  describe "#member?(value)" do
    let(:values) { [5, 3, 8] }
    let(:set) { TreeSet.new(*values) }

    it "should return true if the value is in the set" do
      values.each do |val|
        set.member?(val).should be_true
      end
    end

    it "should return false if the value is not in the set" do
      set.member?(10000).should be_false
    end
  end

  describe "#to_a" do
    it "should return a sorted array containing the elements in the set" do
      set = TreeSet.new(5, 3, 8)
      set.to_a.should == [3,5,8]
    end
  end

  describe "#&(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 4, 9, 10] }
    let(:other_set) { TreeSet.new(*enum) }

    it "should return the intersection of this set and another TreeSet" do
      new_set = set & other_set
      new_set.should be_kind_of(TreeSet)
      new_set.size.should == 3
      new_set.to_a.should == [4, 8, 9]
    end

    it "should return the intersection of this set and an enumerable" do
      new_set = set & enum
      new_set.should be_kind_of(TreeSet)
      new_set.size.should == 3
      new_set.to_a.should == [4, 8, 9]
    end
  end

  describe "#intersection(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 4, 9] }
    let(:other_set) { TreeSet.new(*enum) }

    it "should return the intersection of this set and another TreeSet" do
      new_set = set.intersection(other_set)
      new_set.should be_kind_of(TreeSet)
      new_set.size.should == 3
      new_set.to_a.should == [4, 8, 9]
    end

    it "should return the intersection of this set and an enumerable" do
      new_set = set.intersection(enum)
      new_set.should be_kind_of(TreeSet)
      new_set.size.should == 3
      new_set.to_a.should == [4, 8, 9]
    end
  end

  describe "#|(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [1, 2, 3, 4, 5, 8, 9, 10] }

    it "should return the union of the set and another TreeSet" do
      new_set = set | other_set
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end

    it "should return the union of the set and an enumerable" do
      new_set = set | enum
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end
  end

  describe "#union(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [1, 2, 3, 4, 5, 8, 9, 10] }

    it "should return the union of the set and another TreeSet" do
      new_set = set.union(other_set)
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end

    it "should return the union of the set and an enumerable" do
      new_set = set.union(enum)
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end
  end

  describe "#+(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [1, 2, 3, 4, 5, 8, 9, 10] }

    it "should return the union of the set and another TreeSet" do
      new_set = set + other_set
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end

    it "should return the union of the set and an enumerable" do
      new_set = set + enum
      new_set.count.should == expected_array.length
      new_set.to_a.should == expected_array
    end
  end

  describe "#-(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [2, 3, 4, 5, 9] }

    it "should return a new set with the same elements as self, minus those included in the other set" do
      diff = set - other_set
      diff.should_not == set
      diff.root.should_not == set.root
      diff.length.should == expected_array.length
      diff.to_a.should == expected_array
    end

    it "should return a new set with the same elements as self, minus those included in the other enum" do
      diff = set - enum
      diff.should_not == set
      diff.root.should_not == set.root
      diff.length.should == expected_array.length
      diff.to_a.should == expected_array
    end
  end

  describe "#difference(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [2, 3, 4, 5, 9] }

    it "should return a new set with the same elements as self, minus those included in the other set" do
      diff = set.difference(other_set)
      diff.should_not == set
      diff.root.should_not == set.root
      diff.length.should == expected_array.length
      diff.to_a.should == expected_array
    end

    it "should return a new set with the same elements as self, minus those included in the other enum" do
      diff = set.difference(enum)
      diff.should_not == set
      diff.root.should_not == set.root
      diff.length.should == expected_array.length
      diff.to_a.should == expected_array
    end
  end

  describe "#subtract(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9) }
    let(:enum) { [8, 1, 10] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [2, 3, 4, 5, 9] }

    it "should delete any items in the given TreeSet and return self" do
      ret = set.subtract(other_set)
      ret.should equal(set)
      ret.length.should == expected_array.length
      ret.to_a.should == expected_array
    end

    it "should delete any items in the given enumerable and return self" do
      ret = set.subtract(enum)
      ret.should equal(set)
      ret.length.should == expected_array.length
      ret.to_a.should == expected_array
    end
  end

  describe "#==(other)" do
    let(:set) { TreeSet.new(5, 3, 8, 2, 4, 9, 7) }
    let(:no_match1) { TreeSet.new(1, 2, 3, 4, 5, 6, 7) }
    let(:no_match2) { TreeSet.new(100, 200, 300) }
    let(:matching_set) { TreeSet.new(2, 3, 4, 5, 7, 8, 9) }

    it "should return false for a non TreeSet" do
      set.should_not == Object.new
    end

    it "should return false for a TreeSet with different values" do
      set.should_not == no_match1
      set.should_not == no_match2
    end

    it "should return true for self" do
      set.should == set
    end

    it "should return true for a TreeSet with the same values" do
      set.should == matching_set
    end
  end

  describe "#^(enum)" do
    let(:set1) { TreeSet.new(5, 3, 8) }
    let(:set2) { TreeSet.new(3, 2, 9) }
    let(:set3) { TreeSet.new(4, 1, 7) }

    it "should return the items exclusive between the two sets" do
      (set1 ^ set2).should == TreeSet.new(2, 5, 8, 9)
      (set1 ^ set3).should == TreeSet.new(1, 3, 4, 5, 7, 8)
    end
  end

  describe "#delete(value)" do
    let(:values) { [5, 3, 8, 2, 4, 7] }

    it "should delete the value from the tree if it exists, and return the set" do
      values.each do |val|
        set = TreeSet.new(*values)
        set.delete(val).should == set
        set.length.should == values.length - 1
        values.each do |find_val|
          if val == find_val
            set.should_not include(find_val)
          else
            set.should include(find_val)
          end
        end
      end
    end

    it "should do nothing if the value doesn't exist, and return the set" do
      set = TreeSet.new(*values)
      set.delete(10000).should == set
      set.length.should == values.length
      values.each do |find_val|
        set.should include(find_val)
      end
    end
  end

  describe "#delete?(value)" do
    let(:values) { [5, 3, 8, 2, 4, 7] }

    it "should delete the value from the tree if it exists, and return the set" do
      values.each do |val|
        set = TreeSet.new(*values)
        set.delete?(val).should == set
        set.length.should == values.length - 1
        values.each do |find_val|
          if val == find_val
            set.should_not include(find_val)
          else
            set.should include(find_val)
          end
        end
      end
    end

    it "should do nothing if the value doesn't exist, and return nil" do
      set = TreeSet.new(*values)
      set.delete?(10000).should be_nil
      set.length.should == values.length
      values.each do |find_val|
        set.should include(find_val)
      end
    end
  end

  describe "length/size/count" do
    let(:set) { TreeSet.new(5, 3, 8) }

    describe "#length" do
      it "should return the length of the set" do
        set.length.should == 3
      end
    end

    describe "#size" do
      it "should return the length of the set" do
        set.size.should == 3
      end
    end

    describe "#count" do
      it "should return the length of the set" do
        set.count.should == 3
      end
    end
  end

  describe "#merge(enum)" do
    let(:set) { TreeSet.new(5, 3, 8) }
    let(:enum) { [2, 4, 3, 3, 7] }
    let(:other_set) { TreeSet.new(*enum) }
    let(:expected_array) { [2, 3, 4, 5, 7, 8] }

    it "should add all the elements of another TreeSet to itself and return self" do
      ret = set.merge(other_set)
      ret.should equal(set)
      ret.length.should == expected_array.length
      ret.to_a.should == expected_array
    end

    it "should add all the elements of another enumerable to itself and return self" do
      ret = set.merge(enum)
      ret.should equal(set)
      ret.length.should == expected_array.length
      ret.to_a.should == expected_array
    end
  end

  describe "#subset?(enum)" do
    let(:set) { TreeSet.new(5, 3, 8, 4, 2, 7, 9) }
    let(:subset) { TreeSet.new(8, 3, 4) }
    let(:partial_subset) { TreeSet.new(8, 3, 4, 10) }
    let(:non_subset) { TreeSet.new(10, 20, 30) }

    it "should be true for a subset" do
      set.subset?(subset).should be_true
    end

    it "should be false for non subsets" do
      set.subset?(partial_subset).should be_false
      set.subset?(non_subset).should be_false
    end
  end

  describe "#superset?(enum)" do
    let(:superset) { TreeSet.new(5, 3, 8, 4, 2, 7, 9) }
    let(:set) { TreeSet.new(8, 3, 4) }
    let(:partial_subset) { TreeSet.new(8, 3, 4, 10) }
    let(:non_subset) { TreeSet.new(10, 20, 30) }

    it "should be true for a superset" do
      set.superset?(superset).should be_true
    end

    it "should be false for a non superset" do
      partial_subset.superset?(superset).should be_false
      non_subset.superset?(superset).should be_false
    end
  end

  describe "#each" do
    it "should yield nothing for an empty set" do
      counter = 0
      TreeSet.new.each do |val|
        counter += 1
      end
      counter.should be_zero
    end

    it "should traverse from the root and yield the values of each node" do
      values = [5, 3, 8, 2, 4, 7, 10]
      set = TreeSet.new(*values)
      expectation = values.sort

      index = 0
      set.each do |value|
        value.should == expectation[index]
        index += 1
      end

      index.should == values.length
    end
  end
end