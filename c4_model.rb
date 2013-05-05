class C4Model


  # Sets up the board
  def initialize(row, column, win)
    @board = Array.new(row) {Array.new(column)}
    @current_player = 0
    @win_length = win
    @last_col = 0
    @last_row = 0

  end

  # Places player token
  def place_token(column)

   unless column > @board[0].length-1 || column < 0
      @board.each_index do |i|
         if @board.reverse[i][column].nil?
           @board.reverse[i][column] = @current_player
           @current_player = (@current_player + 1) % 2
           @last_col = column
           @last_row = @board.size-1 - i
           who_won
           return true
         end
      end
     nil
    end
  end

  def check_tie
	  if @board[0].include?(nil) == false
	    raise Interrupt
	end
	nil
  end

  def who_won

    catch (:match) do

      # Checks the row of the last placed token for a win
      x_in_a_row(@board[@last_row])

      # Checks the column of the last inserted token for a win
      array = []
      @board.each_index do |i|
        array.push(@board[i][@last_col])
      end
      x_in_a_row(array)

      # Checks the forward diagonal of the last move  (\)
      array.clear
      start = @last_col - @last_row
      # If we need to check the top half or middle of the board
      if start >= 0
	if (@board[0].length - @last_col) < (@board.length - @last_row)
        (start .. @board[0].length-1).each_with_index do |i, index|
          array.push(@board[index][i])
          x_in_a_row(array)
	  end
	else
        (start .. @board.length-1).each_with_index do |i, index|
          array.push(@board[index][i])
          x_in_a_row(array)
	  end
        end

      # If we need to check the bottom half of the board
      else
        start = @last_row - @last_col
	if (@board[0].length - @last_col) < (@board.length - @last_row)
	 (start .. @board[0].length-1).each_with_index do |i, index|
          array.push(@board[i][index])
          x_in_a_row(array)
          end
	else
	 (start .. @board.length-1).each_with_index do |i, index|
          array.push(@board[i][index])
          x_in_a_row(array)
	  end
        end
      end

      # Checks the backward diagonal of the last move (/)
      array.clear
      
      if @last_col > ((@board.length-1) - @last_row)
	start = @last_col - ((@board.length-1) - @last_row)
	if @last_row > ((@board[0].length-1)-@last_col)
        (start .. @board[0].length-1).each_with_index do |i,index|
          array.push(@board[(@board.length-1)-index][i])
          x_in_a_row(array)
        end
	else
        (start .. (@last_row + @last_col)).each_with_index do |i,index|
          array.push(@board[(@board.length-1)-index][i])
          x_in_a_row(array)
        end
	end
      else
	if @last_row > ((@board[0].length - 1) - @last_col)
	  start = @board[0].length - 1
           (0 .. start).each_with_index do |i,index|
             array.push(@board[@last_row + @last_col - index][i])
             x_in_a_row(array)
         end
	else
	  start = @last_row + @last_col
           (0 .. start).each_with_index do |i,index|
             array.push(@board[@last_row + @last_col - index][i])
             x_in_a_row(array)
         end
	end
      end

      nil
    end

  end

  # Check if there is a winner
  def x_in_a_row(row)
    row.each_index do |i|

      # Already know there is not a match
      unless i + @win_length > row.length

        # Check the part of the array by getting the unique elements
        check = row[i,@win_length].uniq
        unless check.first.nil? or check.count > 1
          throw :match, check.first
        end
      end
    end
  end

  def get_board()
    @board.freeze
  end

  # Prints the current board
  def print_board
    @board.each do |row|
      row.each do |i|
        if i.nil?
          print "| "
        else
          print "|",i
        end
      end
      puts "|"
    end

    # Prints the bottom column numbers if less than 10.
    unless @board[0].length > 9
      @board[0].each_index {|i| print " ",i,""}
      puts ""
    end
  end

end

