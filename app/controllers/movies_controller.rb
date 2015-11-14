class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    if session[:ratings_filter].nil?
      @selected_ratings = @all_ratings
    else
      @selected_ratings = session[:ratings_filter]
    end
    
    unless params[:ratings].blank?
      @selected_ratings = params[:ratings].keys
      session[:ratings_filter] =  @selected_ratings
    end
    
    session[:sort] = params[:sort] || session[:sort]
    
    
    
    case session[:sort]
    when 'title'
      @movies = Movie.where(rating: @selected_ratings).order(:title)
      @title_class = '.hilite'
    when 'release_date'
      @movies = Movie.where(rating: @selected_ratings).order(:release_date)
      @release_date_class = '.hilite'
    else
      @movies = Movie.where(rating: @selected_ratings)
    end 
   
  end

  def new
    # default: render 'new' template
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
