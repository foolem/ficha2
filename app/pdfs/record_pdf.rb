class RecordPdf < Prawn::Document

  def initialize(ficha)
    super(top_margin: 20)
    @ficha = ficha
    header_generate

  end

  def header_generate


    prawn_logo = "app/pdfs/icon.jpg"
    image prawn_logo, :at => [15,740], :width => 80

    text_box  "MINISTÉRIO DA EDUCAÇÃO
    UNIVERSIDADE FEDERAL DO PARANÁ
    SETOR DE CIÊNCIAS EXATAS", size: 11, :at => [100,735]

    text_box  "DEPARTAMENTO DE MATEMÁTICA", size: 11, :at => [100,680]

    move_down 80
    stroke_horizontal_rule

    move_down 10
    text  "PLANO DE ENSINO", size: 11, style: :bold, align: :center
    text  "Ficha n° 2 (variável)", size: 11, align: :center



#http://prawnpdf.org/docs/0.11.1/index.html
#http://prawnpdf.org/manual.pdf

#https://github.com/prawnpdf/prawn-table

  end

end
