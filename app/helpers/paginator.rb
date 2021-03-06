module Paginator

  def render_pages(list, page, path, length)
    pages = pages_count(list, length)

    if(pages < 1)
      return ' '
    end
    page = page.to_i
    if(page.blank? or page == 0 )
      page = 1;
    end

    inicial = 1
    if(page > 4)
      inicial = page - 2

      if page + 2 > pages
        inicial -= 2
      end
    elsif page == 4 && pages > page + 1
      inicial = page - 2
    end

    if page == inicial + 4 && inicial + 5 <= pages
      inicial += 1
    end

    maximo = inicial + 4
    if(pages < 5)
      maximo = pages
    end

    resultado = ' '
    for i in inicial..maximo
      if i == page
        resultado = resultado + ' <li class="active black"><a href="' + path +'?page=' + i.to_s + '">' + i.to_s + '</a></li>'
      else
        resultado = resultado + ' <li><a href="'+ path +'?page=' + i.to_s + '">' + i.to_s + '</a></li>'
      end
    end

      if(page <= 1)
        classe = 'class="disabled"'
        link = path + "?page=#{page.to_s}"
      else
        classe = ''
        link = path + "?page=#{(page-1).to_s}"
      end

      pre_page ='<li '+ classe +' > <a href="'+ link +
      '" aria-label="Previous"> <span aria-hidden="true">&laquo;</span> </a> </li>'

      if(page >= pages)
        classe = 'class="disabled"'
        link = path + "?page=#{page.to_s}"
      else
        classe = ''
        link = path + "?page=#{(page+1).to_s}"
      end

      next_page =
      '<li '+ classe +' > <a href="'+ link +
      '" aria-label="Next"> <span aria-hidden="true">&raquo;</span> </a> </li>'

      result = pre_page +' '+ resultado +' '+ next_page

    return result
  end

  def pages_verify(page, lines, length)
    pages = pages_count(lines, length)
    if(page < 1)
      page = 1
    elsif page > pages
      page = pages
    end
    page
  end

  def pages_count(num, length)
    puts num
    pages = num/length
    resto = num.remainder length
    if( resto > 0)
      pages = pages + 1
    end
    pages
  end

end
