class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.possible_ratings
    @chosen_ratings = @all_ratings
    
    if !session[:current_ratings].nil?
      @chosen_ratings = session[:current_ratings]
    end
    if params[:ratings].present?
      @chosen_ratings = params[:ratings].keys
      session[:current_ratings] = @chosen_ratings
    end
    
    
    if !session[:sort].nil?
      @chosen_sort = session[:sort]
    end
    if params[:sort].present?
      @chosen_sort = params[:sort]
      session[:sort] = @chosen_sort
    end
      
    
    case @chosen_sort
    when 'title'
      @movies = Movie.where("rating in (?)", @chosen_ratings).order('title asc')
      @title_hilite = 'hilite'
    when 'release_date'
      @movies = Movie.where("rating in (?)", @chosen_ratings).order('release_date asc')
      @release_date_hilite = 'hilite'
    else
      @movies = Movie.where("rating in (?)", @chosen_ratings)
    end
  end

  def new
    # default: render 'new' template
    #
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end