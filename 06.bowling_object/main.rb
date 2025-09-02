require_relative 'game'

marks = ARGV[0]
game = Game.new(marks)

puts "合計点数は #{game.total_score} です"
