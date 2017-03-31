
# The Vertex and Graph classes are not used in the final version of the program. 
# Nevertheless, I decided to not delete them, as they can be refactored
# and used to further experiment with graphs.

=begin
class Vertex
	attr_accessor :position, :adjacent

	def initialize position,adjacent=[]
		@position = position
		@adjacent = adjacent
	end
end

class Graph
	attr_accessor :vertices

	def initialize
		@vertices = []
	end

	def add_vertex(vertex)
		@vertices.push vertex
	end

	def find_vertex vertex_to_find
		@vertices.each do |vertex|
			return vertex if vertex_to_find == vertex.position
		end
	end
end
=end


class Board
	attr_accessor :board, :knight_position, :moves_graph_hash, :old_positions

	def initialize
		@board = [["", 1, 2, 3, 4, 5, 6, 7, 8],
							[1," "," "," "," "," "," "," "," "],
							[2," "," "," "," "," "," "," "," "],
							[3," "," "," "," "," "," "," "," "],
							[4," "," "," "," "," "," "," "," "],
							[5," "," "," "," "," "," "," "," "],
							[6," "," "," "," "," "," "," "," "],
							[7," "," "," "," "," "," "," "," "],
						  [8," "," "," "," "," "," "," "," "]]
		@knight_position = []
		@moves_graph_hash = {}
		@old_positions = []
	end

	def show
		puts @board.map { |line| line.map { |square| square.to_s.rjust(1) }.join(" ") }
	end

	def create_knight																# Creates a knight at a random place on the board.
		@board[rand(1..8)][rand(1..8)] = :k
		@board.select do |line|
			if line.include?(:k)
				@knight_position.push @board.index(line)
				line.select { |square| @knight_position.push line.index(square) if square == :k}
			end
		end
	end


	def calculate_moves position=@knight_position
		possible_moves = []
		possible_moves.push([position[0] + 2,position[1] + 1]) if position[0] + 2 <= 8 && position[1] + 1 <= 8
		possible_moves.push([position[0] + 2,position[1] - 1]) if position[0] + 2 <= 8 && position[1] - 1 >= 1
		possible_moves.push([position[0] + 1,position[1] + 2]) if position[0] + 1 <= 8 && position[1] + 2 <= 8
		possible_moves.push([position[0] + 1,position[1] - 2]) if position[0] + 1 <= 8 && position[1] - 2 >= 1
		possible_moves.push([position[0] - 1,position[1] + 2]) if position[0] - 1 >= 1 && position[1] + 2 <= 8
		possible_moves.push([position[0] - 1,position[1] - 2]) if position[0] - 1 >= 1 && position[1] - 2 >= 1
		possible_moves.push([position[0] - 2,position[1] + 1]) if position[0] - 2 >= 1 && position[1] + 1 <= 8
		possible_moves.push([position[0] - 2,position[1] - 1]) if position[0] - 2 >= 1 && position[1] - 1 >= 1
		possible_moves
	end

	def create_graph_hash position=@knight_position										# Creates an adjacency list whose first key is the current position
		@moves_graph_hash[position] = calculate_moves position   				# and includes all possible moves.
		@old_positions.push position
		@moves_graph_hash[position].each do |new_position|
			create_graph_hash new_position if !@old_positions.include? new_position
		end	
	end

	def show_all_moves																								# Can be used to visualize the adjacency list with all possible moves.
		@moves_graph_hash.each do |position,moves|
			puts "#{position} => #{moves}"
		end
	end

	def create_graph 																									# Used to create a graph based on the adjacency list with all possible moves
		graph = Graph.new 																							# and the Graph and Vertex classes in the beginning.
		@moves_graph_hash.each do |position,adjacent|										# Also not used in the final implementation.
			new_vertex = Vertex.new(position)
			graph.add_vertex new_vertex
			new_vertex.adjacent = adjacent
		end
		graph
	end
end

def knight_moves(start,finish) 																			# Main method.
	game = Board.new
	game.create_knight
	game.knight_position = start
	game.create_graph_hash game.knight_position
	graph_hash = game.moves_graph_hash

	if start == finish
		return "You're on the same tile."
	end

	path = []				
	steps = {}			# In order to backtrack the adjacent tile at each step and push it to the path.
	n = 1 					# In order to push the new tiles that correspond to each step in the steps hash.
	queue = []			# In order to check if the final tile is among the newly reached.
	visited = []		# In order to not check the same tile twice.
	moves = 0
	graph_hash[start].each { |new_tile| queue.push new_tile }
	steps[n] = queue.clone				# Each index in the steps hash needs to include only the newly reached tiles.

	while true
		moves += 1
		if queue.include? finish
			if moves == 1
				puts "You can make it in one move."
				break
			elsif moves > 1
				puts "You can make it from #{start} to #{finish} in #{moves} moves."
		    break
		  end
		else
			queue.each do |visited_tile|
				visited.push visited_tile
			end

			index = queue.length - 1
			i = 0
			while i < index
				graph_hash[queue[i]].each do |new_tile| 
					queue.push new_tile if !visited.include? new_tile
					visited.push new_tile
				end
				i += 1
			end
			queue.slice!(0..i)
			n += 1
			steps[n] = queue.clone					# Add the newly reached tiles to the next index in the steps hash.
		end
	end

	m = steps.length - 1								# Backtrack every adjacent square and push it to the path array.
	current = finish.clone
	path.push current
	while m > 0
		steps[m].each do |position| 
		 if graph_hash[current].include? position
		 	path.push position
		 	break
		 end
		end
		current = path.last.clone
		m -= 1
	end
	path.reverse!.unshift start					# The path was bakctracked and didn't contain the first tile. Amend that.
	path.each { |step| puts step.to_s }
end

=begin 							# Not really needed for the knight_moves method.
game = Board.new
game.create_knight
game.show
=end

knight_moves([1,5],[8,2])
knight_moves([1,1],[8,8])
knight_moves([3,6],[6,3])