# encoding: utf-8

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


	def knight_moves(start=@knight_position,finish)
		# Refactor
		game = Board.new
		game.create_graph_hash(start)
		graph = game.create_graph

		moves = []
		moves_count = 0
		queue = []
		n = 0
		current = start

		if start == finish
			return "You're on the same tile."
		elsif graph.vertices[0].adjacent.include? finish
			return "You can make it in one move."
		else
			# What to do?
		end
		# puts "You reached #{finish} in #{move_count} moves." + moves
		end
	end


end

# Tests:
=begin
game = Board.new
game.create_knight
game.show

p game.knight_position
p game.calculate_moves
#p game.calculate_moves([5,5])
game.create_graph_hash([5,5])
#game.show_all_moves
graph = game.create_graph
p graph.vertices[2]
b = graph.find_vertex [6,7]
p b.adjacent

#p game.moves_graph_hash[[1,3]].include? [2,5]
#p game.moves_graph_hash[[1,3]].include? [2,6]

# p game.knight_moves([5,5],[7,7])
=end