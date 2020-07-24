class GameController < ApplicationController
  
  before_action :get_game_from_session
  after_action :store_game_in_session
  
  def store_game_in_session
      session[:game] = @game.to_yaml
  end
    
  def get_game_from_session
      if !session[:game].blank?
          @game = YAML.load(session[:game])
      else
          @game = WordGame.new('')
      end
  end
    
  def win
  end

  def lose
  end

  def show
  end

  def new
  end

  def create
      word = params[:word] || WordGame.get_random_word
      @game = WordGame.new word
      
      num = params[:num_guesses]
      
      if num =~ /[^0-9]/
          flash[:message] = "Please enter a number between 0 and 9"
          redirect_to game_new_path
          return
      elsif num.length == 0
          @game.num_guesses = 7
      else
          @game.num_guesses = num
      end
      redirect_to game_show_path
  end

  def guess
      letter = params[:guess].to_s[0]
      
      if @game.guess_illegal_argument? letter
          flash[:message] = "Invalid guess."
      elsif !@game.guess letter
          flash[:message] = "You have already used that letter"
      end
      
      if @game.check_win_or_lose == :win
          redirect_to game_win_path
      elsif @game.check_win_or_lose == :lose
          redirect_to game_lose_path
      else
          redirect_to game_show_path
      end
  end
    
end
