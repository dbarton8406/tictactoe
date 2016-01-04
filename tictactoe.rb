=begin
So the first thing I usually do when I refactor code is start from the entry point and work my way through function by function.
Before I start breaking down the functions, I will note that you have some free wrangling code (i.e Progress bar, "Is it a game"...). It is generally bad practice to mix functions and free executing code. I've moved them into functions so it's a little cleaner to read and know what's going on.

Functions:
1. play
   - This appears to be the opening function. I've added a new show_opening_statement function that will print your progress bar and opening statement. 
   - So most programming languages have two main types of loops. FOR loops and WHILE loops. You use an UNTIL loop which is just an anti-WHILE loop.
      -- while (true) is the same thing until (false)
   - So what you are trying to do in this function is do something at least once. Fortunately there is a concept called DO-WHILE. These type of WHILE loops do the code once and then execute a loop condition. Ruby has two ways to do this. My play function uses this logic. 
   - If you compare, which one looks cleaner?
2. show_opening_statement
   - This now contains your progress bar and "Is it a game..." stuff
3. play_tictactoe && tictactoe
   - It doesn't make sense to have both of these functions since one of them just calls the other one. So I combined them into one.
   - I moved the board to be 0 to 8 because it doesn't really make sense to make it 0 to 9 to solve a conversion problem.
4. valid_number?
   - Just a common beginner's error. It's a waste to say if something returns true, then return true, else if it is false, return false. Let me know if that doesn't make sense.
   - I've also added a is_numeric? function. This will check to see if the string is a number. I didnt know how to do this so I googled it. I think this is a better solution to "Is input a number" than shift board values 1. 


Like I said, I think this was fine. There were just some noticeable minor things that could be refactored. Obviously this should be refactored more, like classes which you already have. For a simple tictactoe game, I think this is good.
=end

require "pry"
require "set"
require "colorize"
require 'progress_bar'

$win_set =Set.new([Set.new([0,3,6]),Set.new([1,4,7]),
                   Set.new([2,5,8]),Set.new([0,1,2]),Set.new([3,4,5]),
                   Set.new([6,7,8]),Set.new([0,4,8]),Set.new([2,4,6])])
# def play
#   play_tictactoe
#   choice = play_again?
#   until choice == "n"
#     play_tictactoe
#     choice = play_again?
#   end
# end

def play
  show_opening_statement

  loop do
    play_tictactoe
    break if play_again? == "n"
  end
end

def show_opening_statement
  bar = ProgressBar.new

  100.times do
    sleep 0.05
    bar.increment!
  end

  
  "Is it a game... or is it real?\n\n".each_char { |c|
    putc c
    sleep 0.05
    $stdout.flush
  }

  "What you see on these screens up here is a fantasy;
  a computer enhanced hallucination!\n\n".each_char { |c| 
    putc c
    sleep 0.05
    $stdout.flush
  }
end

def play_again?
  puts "Would you like to play again? (y/n)"
  choice = gets.chomp
end

def play_tictactoe
  turn_count = 9
  board = (0..8).to_a
  
  # player1
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts "================================================================================"
  puts"Please type your first name.".blue.bold
  puts "================================================================================"
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  player1 = gets.chomp

  # player2
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts "================================================================================"
  puts"Please type your first name.".red.bold
  puts "================================================================================"
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  player2 = gets.chomp
  
  g1 = Set.new
  g2 = Set.new
  greeting
  guesses = g1
  current_player = player1

  until game_over?(guesses,turn_count)
    puts "<<<<<<<<<<<<<<<<<<<<<<<"
    puts current_player
    puts "<<<<<<<<<<<<<<<<<<<<<<<"
    
    guess = take_turn(guesses,board)
    turn_count -= 1
    guesses.add(guess)
    
    if current_player == player1
      board[guess] = "X"
      if win?(guesses)
        puts "#{player1} wins!\n\n".blue.blink
        puts "===================="
      else
        current_player = player2
        guesses = g2
      end
    else
      current_player = player1
      board[guess] = "O"
      if win?(guesses)
        puts "#{player2} wins!\n\n".red.blink
        puts "===================="
      else
        guesses = g1
      end
    end
  end
  postmortem(guesses, board)
end

def greeting
  "\n\n\nGreetings, Dr.Falken,\n\n".each_char {|c|
    putc c
    sleep 0.15;
  $stdout.flush }
  sleep 1
  "shall we play a game?\n\n".each_char {|c|
    putc c
    sleep 0.15;
  $stdout.flush }
  sleep 1
  "Global Thermonuclear War? \n\n ".each_char {|c|
    putc c
    sleep 0.05;
  $stdout.flush }
  sleep 1
  "No,just tic tac toe.\n\n\n\n\n\n".each_char {|c|
    putc c
    sleep 0.05;
  $stdout.flush }
end

def game_over?(guesses,turn_count )
  turn_count == 0 || win?(guesses)
end

def win?(guesses)
  $win_set.any? {|x| x.subset?(guesses)}
end

def take_turn(guesses, board)
  show_board(board)
  prompt_player(board)
end

def show_board(board)
  puts "
#{board[0]} | #{board[1]} | #{board[2]}
--- --- ---
#{board[3]} | #{board[4]} | #{board[5]}
--- --- ---
#{board[6]} | #{board[7]} | #{board[8]}
\n\n"
end

def prompt_player(board)

  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  puts "Please choose a open square:".green.bold
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  choice = gets.chomp
  until valid_number?(choice) && !already_guessed?(board,choice.to_i)
    puts "#{choice} is not a valid option.
Please choose again: "
    choice = gets.chomp
  end
  choice.to_i
end

def valid_number?(choice)
  is_numeric?(choice) && choice.to_i >= 0 && choice.to_i <= 8
end

def is_numeric?(s)
    !!Float(s) rescue false
end

def already_guessed?(board,choice)
  board[choice]=="X" || board[choice]=="O"
end

def postmortem( guesses, board)
  if win?(guesses)
    "what is the primary goal?\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    sleep 1
    "You should know, Professor you programmed me.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    sleep 1
    "To win the game.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
  else
    "==========="
    puts "Tie".green.blink
    "===========\n\n"
    "Greetings, Professor Falken\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    sleep 1
    " A strange game.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    "The only winning move is not to play.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    "How about a nice game of chess?\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
  end
end
play
