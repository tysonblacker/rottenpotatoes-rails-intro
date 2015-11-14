module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def get_header_hilite(column)
    if session[:sort_type] == column
      "hilite"
    else
      ""
    end
  end
  
end
