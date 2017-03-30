
class Node
	attr_accessor :value, :parent_node, :left_child, :right_child

	def initialize(value,parent_node=nil,left_child=nil,right_child=nil)
		@value = value
		@parent_node = parent_node
	end
end

class BinaryTree
	attr_accessor :root

	def initialize
		@root = nil
	end

=begin 															# This part is unnecessary.
	def insert node,parent
		return node if parent.nil?
		if node.value <= parent.value && parent.left_child.nil?
			parent.left_child = node
		elsif node.value <= parent.value && !parent.left_child.nil?
			insert(node,parent.left_child)
		elsif node.value > parent.value && parent.right_child.nil?
			parent.right_child = node
		else
			insert(node,parent.right_child)
		end
		node
	end
=end

	def build_tree array
		@root = Node.new(array.shift)
		parent = @root
		array.each do |el|
			while true
				if el <= parent.value
					if parent.left_child.nil?
						parent.left_child = Node.new(el,parent)
						break
					else
						parent = parent.left_child
					end
				elsif el > parent.value
					if parent.right_child.nil?
						parent.right_child = Node.new(el,parent)
						break
					else
						parent = parent.right_child
					end
				end
			end
		end
	end

	def breadth_first_search value,node=@root
		queue = []
		queue.push node
		while !queue.empty?
			if value == queue[0].value
				return "The node you're searching for is #{node} with value #{node.value}."
			else
				queue.push node.left_child if !node.left_child.nil?
				queue.push node.right_child if !node.right_child.nil?
				queue.shift
				node = queue[0]
			end
		end
		return nil if queue.empty?
	end

	def depth_first_search value,node=@root	# Non-recursive pre-order depth first search. 
		stack = []
		stack.push node
		while !stack.empty?
			if value == stack.last.value
				return "The node you're searching for is #{node} with value #{node.value}."
			elsif	!node.left_child.nil?
				stack.pop
				stack.push node.left_child
			else
				stack.pop
				stack.push node.right_child if !node.right_child.nil?
			end
			node = stack.last
		end
		return nil if stack.empty?
	end

	def dfs_rec value,node=@root	# Recursive pre-order depth first search. 
		return nil if node.nil?
		if value == node.value
			return "The node you're searching for is #{node} with value #{node.value}."
		elsif !node.left_child.nil?
			dfs_rec(value,node.left_child)
		else
			dfs_rec(value,node.right_child)
		end
	end
end

# Tests:
#=begin
tree = BinaryTree.new
tree.build_tree [12,3,4,7,123,10,5,6,66]
p tree.root.value
p tree.breadth_first_search 3
p tree.breadth_first_search 50 # Should return nil
p tree.depth_first_search 6
p tree.depth_first_search 100 # Should return nil
p tree.dfs_rec 66
p tree.dfs_rec 77	# Should return nil

# The next two should be equal

p tree.root.left_child.value
p tree.root.left_child.right_child.parent_node.value
#=end