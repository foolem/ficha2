class RecordPdf < Prawn::Document

  def initialize(ficha)
    super(top_margin: 20)
    @ficha = ficha
    matter_generate
    start_new_page
    record_generate
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

    move_down 17
    text  "PLANO DE ENSINO", size: 12, style: :bold, align: :center
    text  "Ficha n° 2 (variável)", size: 11, align: :center
    move_down 20

  end

  def matter_generate

    header_generate
    bounding_box([50,cursor],:width=>450,:height=>cursor) do
      transparent(0.5){stroke_bounds}

      move_down 5
      text_box "Disciplina:", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.name(), size: 11, :at => [70,cursor]

      text_box "Código:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.code(), size: 11, :at => [285,cursor]

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      move_down 5
      text_box "Natureza: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.nature(), size: 11, :at => [64,cursor]

      text_box "Tipo:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.kind(), size: 11, :at => [270,cursor]

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      move_down 5
      text_box "Pré-requisito: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.prerequisite(), size: 11, :at => [85,cursor]

      text_box "Co-requisito:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.corequisite, size: 11, :at => [310,cursor]

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      move_down 5
      text_box "Modalidade: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.modality(), size: 11, :at => [80,cursor]

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      move_down 15
      text_box "C. H. Semestral Total: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.total_weekly_workload().to_s + "h", size: 11, :at => [127,cursor]

      text_box "PD:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.pd().to_s, size: 11, :at => [263,cursor]

      text_box "OR:", size: 11, style: :bold, :at => [300,cursor]
      text_box @ficha.matter.or().to_s, size: 11, :at => [323,cursor]

      move_down 15
      text_box "C. H. Anual Total: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.total_annual_workload().to_s + "h", size: 11, :at => [104,cursor]

      text_box "LC:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.lc().to_s, size: 11, :at => [263,cursor]

      move_down 15
      text_box "C. H. Modular Total: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.total_modular_workload().to_s + "h", size: 11, :at => [117,cursor]

      text_box "CP:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.cp().to_s, size: 11, :at => [263,cursor]

      move_down 15
      text_box "C. H. Semanal: ", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.matter.weekly_workload().to_s + "h", size: 11, :at => [92,cursor]

      text_box "ES:", size: 11, style: :bold, :at => [240,cursor]
      text_box @ficha.matter.es().to_s, size: 11, :at => [263,cursor]


      move_down 25
      transparent (0.5) { stroke_horizontal_rule }

      move_down 15
      text_box "EMENTA", size: 12, style: :bold, :at => [0,415], align: :center

      move_down 15
      text_box @ficha.matter.menu.to_s, size: 11, :at => [10,cursor]

      move_down 30
      transparent (0.5) { stroke_horizontal_rule }

      move_down 15
      text_box "PROGRAMA", size: 12, style: :bold, :at => [0,355], align: :center

      move_down 15
      text_box @ficha.program, size: 11, :at => [10,cursor]

  end

  def record_generate
    header_generate

    bounding_box([50,cursor],:width=>450,:height=>cursor) do
      transparent(0.5){stroke_bounds}

      move_down 5
      text_box "Professor:", size: 11, style: :bold, :at => [10,cursor]
      text_box @ficha.user.name(), size: 11, :at => [70,cursor]

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }


      move_down 15
      text_box "OBJETIVO GERAL", size: 12, style: :bold, :at => [0,560], align: :center

      move_down 15
      text_box @ficha.general_objective, size: 11, :at => [10,cursor]


      move_down 30
      transparent (0.5) { stroke_horizontal_rule }


      move_down 30
      text_box "OBJETIVOS ESPECÍFICOS", size: 12, style: :bold, :at => [0,500], align: :center

      move_down 15
      text_box @ficha.specific_objective, size: 11, :at => [10,cursor]

    end

  end



#http://prawnpdf.org/docs/0.11.1/index.html
#http://prawnpdf.org/manual.pdf

#https://github.com/prawnpdf/prawn-table

  end

end
