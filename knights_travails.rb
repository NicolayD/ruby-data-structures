
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

	def create_knight
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

	def create_graph_hash position=@knight_position
		@moves_graph_hash[position] = calculate_moves position
		@old_positions.push position
		@moves_graph_hash[position].each do |new_position|
			create_graph_hash new_position if !@old_positions.include? new_position
		end	
	end

	def show_all_moves
		@moves_graph_hash.each do |position,moves|
			puts "#{position} => #{moves}"
		end
	end

	def create_graph
		graph = Graph.new
		@moves_graph_hash.each do |position,adjacent|
			new_vertex = Vertex.new(position)
			graph.add_vertex new_vertex
			new_vertex.adjacent = adjacent
		end
		graph
	end
end

def knight_moves(start,finish)
	game = Board.new
	game.create_knight
	game.knight_position = start
	game.create_graph_hash game.knight_position
	graph_hash = game.moves_graph_hash

	if start == finish
		return "You're on the same tile."
	end

	queue = []
	visited = []
	moves = 0
	graph_hash[start].each { |new_tile| queue.push new_tile }

	while true
		moves += 1
		if queue.include? finish
			return "You can make it in 1 move" if moves == 1
			return "You can make it in #{moves} moves." if moves > 1
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
		end
	end
	
end

game = Board.new
game.show

p knight_moves([7,8],[8,8])