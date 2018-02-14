
word_corpus_array = ["strings", "things", "icing", "imagination", "ocean", "jungle", "fairy", "desk", "tart", "chair", "mountain", "beach", "fridge", "fancy", "river", "mushroom", "books", "sticker", "mango", "street", "lucky", "paper", "crystal", "plant", "cactus", "author", "ship", "canoe", "happy", "jump"]


# This method choses a word at random from the word_corpus_array

def word_selection (corpus_array)
  target_word = corpus_array.sample
  return target_word
end

# This method takes the length of the selected word and generates an
# array of blanks of the same length.
def generate_solution_array (letter_array_length)
  array_o_blanks = []
  letter_array_length.times do
    blank = "_"
    array_o_blanks << blank
  end
  return array_o_blanks
end

=begin This suite of methods uses the two private methods above
along with the .length method and .split method to choose a word
from the word corpus array and convert it into the input the values
that an instance of the Solution class needs.
=end

our_target_word = word_selection(word_corpus_array)
our_target_word_array = our_target_word.split('')
target_length = our_target_word_array.length
solution_array = generate_solution_array(target_length)



class Solution
  attr_accessor :guess_word, :guess_word_array, :guess_word_length, :guess_solution_array, :failed_guess_count, :fails_allowed
  def initialize (guess_word, guess_word_array, guess_word_length, guess_solution_array)
    @guess_word = guess_word
    @guess_word_array = guess_word_array
    @guess_word_length = guess_word_length
    @guess_solution_array = guess_solution_array
    @failed_guess_count = 0
    @fails_allowed = 5
    @piranhas = [
      " ><(((('> ",
      " ><(((('> ><(((('> ",
      " ><(((('> ><(((('> ><(((('> ",
      " ><(((('> ><(((('> ><(((('> ><(((('> ",
      " ><(((('> ><(((('> ><(((('> ><(((('> ><(((('> "
      ]
  end

  def identify_match_locations(user_guess)
    iterations = @guess_word_length - 1
    match_position_array = []
    for i in 0..iterations
      if @guess_word_array[i] == user_guess
        match_position = i
        match_position_array << match_position
      end
    end
    return match_position_array
  end

  def guess_succeed_or_fail(array_of_matches_found)
    if array_of_matches_found.none?
      #the puts statement below is temporary and just for testing.
      puts "\nYour guess failed.\n"
      @failed_guess_count += 1
    else
      puts "\nYou guessed a correct letter!\n"
    end
  end

  def replace_blank_with_successful_guess(identified_match_positions, user_guess)
    original_guess_solution_array = @guess_solution_array
    identified_match_positions.each do |location|
      @guess_solution_array.insert(location, user_guess)
      @guess_solution_array.delete_at(location + 1)
    end
  end

  def piranhas
    puts "Now, a school of #{@failed_guess_count} piranha(s) has come to eat you!"
    puts @piranhas[@failed_guess_count - 1]
  end

  def guesses_left
    guesses_remaining = @fails_allowed - @failed_guess_count
    puts "\n\nYou have #{guesses_remaining} failed guess(es) remaining."
    return guesses_remaining
  end

  def test_for_loss
    if @failed_guess_count == 5
      #These 'Puts' statements are temporary, for testing.
      puts "\nThe piranhas ate you! You have lost!"
      exit
      #puts "The piranhas are circling, but you're still alive."
    end
  end

  def check_for_win
      if !@guess_solution_array.include?("_")
        #Temporary output for TESTING
        puts "\nYou have survived the piranha attack! You win."
        #puts "The Pirhanas are getting hungrier!"
        exit
      end
  end
end


class GuessRecord
  attr_accessor :array_of_guessed_letters

  def initialize
    @array_of_guessed_letters = []
  end


  def update_guess_array (guessed_letter)
    @array_of_guessed_letters << guessed_letter
  end

  def get_number_of_guesses
    number_of_guesses = @array_of_guessed_letters.length
    # puts "You have made #{number_of_guesses} guess(es).\n"
    return number_of_guesses
  end

end

# STANDALONE METHOD FOR GUESS SOLICITATION

def solicit_guess
  puts "Please guess a letter: "
  guess = gets.chomp
end

# INSTANTIATE NECESSARY CLASSES

test_solution = Solution.new(our_target_word, our_target_word_array, target_length, solution_array)

test_guess_record = GuessRecord.new

# PROCEDURE FOR RENDERING INITIAL DISPLAY
puts "\n\n"
puts "Welcome to Word Guessing Game!\n"
puts "If you guess wrong, piranhas will start to appear and if you lose, they will eat you! No pressure or anything.\n\n"
puts "________________________________________\n\n"
puts "#{solution_array}"#solution_array  {Note -- not processed via class}
puts "\n\nYou get #{test_solution.fails_allowed} guesses!\n\n"

#Until (win || loss) do

until test_solution.test_for_loss || test_solution.check_for_win do


  player_guess = solicit_guess

  test_guess_record.update_guess_array(player_guess)

  puts "Here are the letters you've guessed so far: #{test_guess_record.array_of_guessed_letters}"

  first_match_array = test_solution.identify_match_locations(player_guess)
  # puts "#{test_solution.guess_word}" #this shows the solution word

  if !test_solution.guess_succeed_or_fail(first_match_array)
    test_solution.replace_blank_with_successful_guess(first_match_array, player_guess)
  end

  print test_solution.guess_solution_array

  test_solution.check_for_win

  test_guess_record.get_number_of_guesses

  #piranhas_needed = test_guess_record.get_number_of_guesses

  test_solution.test_for_loss

  test_solution.guesses_left

  test_solution.piranhas

end
