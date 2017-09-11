module Paginator
  
  def self.pages_verify(page, lines)
    pages = pages_count(lines)
    if(page < 1)
      page = 1
    elsif page > pages
      page = pages
    end
    page
  end

  def self.pages_count(num)
    pages = num/10
    resto = num.remainder 10
    if( resto > 0)
      pages = pages + 1
    end
    pages
  end

end
