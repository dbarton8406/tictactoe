require "pry"
require "set"
$win_set =Set.new([Set.new([0,1,2]),Set.new([3,4,5]),
                   Set.new([6,7,8]),Set.new([0,3,6]),Set.new([1,4,7]),
                   Set.new([2,7,8]),Set.new([0,4,8]),Set.new([2,4,6])])
def play
  play_tictactoe
  choice = play_again?
  until choice == "n"
    play_tictactoe
    choice = play_again?
  end
end
def play_again?
  puts "Would you like to play again? (y/n)"
  gets.chomp
end
def play_tictactoe
  tictactoe
end
"Is it a game... or is it real?\n\n".each_char {|c| putc c ;
sleep 0.05; $stdout.flush }
"What you see on these screens up here is a fantasy;
a computer enhanced hallucination!\n\n".each_char {|c| putc c ;
sleep 0.05; $stdout.flush }
def tictactoe
  turn_count = 9
  board = (0..8).to_a
  # player1 
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts "================================================================================"
  puts"Please type your first name."
  puts "================================================================================"
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  player1 = gets.chomp

  # player2 
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  puts "================================================================================"
  puts"Please type your first name."
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
        puts "#{player1} wins!\n\n"
        puts "===================="
      else
        current_player = player2
        guesses = g2
      end
    else
      current_player = player1
      board[guess] = "O"
      if win?(guesses)
        puts "#{player2} wins!\n\n"
        puts "===================="
      else
        guesses =g1
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
  puts "Please choose a open square:"
  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  choice = gets.chomp
  until valid_number?(choice.to_i) || !already_guessed?(board,choice>to_i)
    puts "#{choice} is not a valid option.
Please choose again: "
    choice = gets.chomp
  end
  choice.to_i
end
def valid_number?(choice)
  if choice >= 0 and choice <= 8
    true
  else
    false
  end
end
def already_guessed?(board,choice)
  board[choice] == "X" || board[choice] == "O"
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
    sleep 1
    puts "congrats you win!"
  else
    "==========="
    puts "Tie"
    "===========\n\n"
    "Greetings, Professor Falken\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    sleep 1
    "Hello,Joshua.\n".each_char {|c| putc c
    sleep 0.25; $stdout.flush }
    " A strange game.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    "The only winning move is not to play.\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
    "How about a nice game of chess?\n".each_char {|c| putc c
    sleep 0.05; $stdout.flush }
  end
end
play
