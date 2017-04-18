module FichasHelper

  def status_representation(status)
    if(status == "Aprovado")
      return "✓"
    end
      return status
  end
end
