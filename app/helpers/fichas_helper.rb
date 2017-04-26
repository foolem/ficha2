module FichasHelper

  def status_representation(status)
    if(status == "Aprovado")
      return "✓"
    end
      return status
  end

  def count_lines(text)
    ((text.length / 80) + text.lines.count) 
  end

end
