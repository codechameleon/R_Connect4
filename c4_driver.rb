require 'c4_model'


class InvalidInput < ArgumentError
end

class C4Driver

  # Defaults and optional command line inputs
  row, column =  8, 8
  length_to_win = 4
  if ARGV.length > 0 and ARGV.length < 3
    row,column = ARGV[0].to_i
    length_to_win = ARGV[1].to_i

  else if ARGV.length >= 3
         row = ARGV[0].to_i
         column = ARGV[1].to_i
         length_to_win = ARGV[2].to_i
       end
  end

  # Set up game
  game = C4Model.new(row,column,length_to_win)
  game.print_board
  player = 0

  catch(:quit) do
  # play game
    winner = nil
    until winner do
          turn = nil
      # Take turn
      until turn do
        begin
         print "Player ", player, " enter column."
         picked = nil

         # Error checking for input
         until picked do
            begin
              input = STDIN.gets.chomp

              throw :quit if input.eql?"quit"

              picked = Integer(input)

            rescue ArgumentError
              print "Not an integer! Try again:"
            end
         end
         # place token
         if game.place_token(picked).nil?
           raise InvalidInput
         end
         game.print_board

         winner = game.who_won
	# game.check_tie
         turn = 1
         player = (1 + player) % 2
        rescue InvalidInput
         puts "Invalid input. Try again"

        end
      end
    end
  print "Player ",(1 - player) % 2, " won!"
  puts ""

  end
	#rescue Interrupt
	#puts "It was a tie game."
	#end
  puts "Thanks for playing"
end
