class RecordPdf < Prawn::Document

  def initialize(ficha)
    super(top_margin: 20)
    @ficha = ficha
    @margem = 50
    matter_generate
    start_new_page
    record_generate
  end

  def header_generate
    prawn_logo = "app/pdfs/icon.jpg"
    image prawn_logo, :at => [@margem,740], :width => 80

    text_box  "MINISTÉRIO DA EDUCAÇÃO
    UNIVERSIDADE FEDERAL DO PARANÁ
    SETOR DE CIÊNCIAS EXATAS", size: 11, :at => [85+ @margem,735]

    text_box  "DEPARTAMENTO DE MATEMÁTICA", size: 11, :at => [85 + @margem,680]
    move_down 80

    stroke_horizontal_line @margem,450 + @margem,:at=> cursor

    move_down 17
    text  "PLANO DE ENSINO", size: 12, style: :bold, align: :center
    text  "Ficha n° 2 (variável)", size: 11, align: :center
    move_down 20

  end

  def matter_generate

    header_generate
    bounding_box([50,cursor],:width=>450,:height=>cursor - 50) do
      transparent(0.5){stroke_bounds}

      simple_title_generate("Disciplina:", 10, 5)
      show_value(@ficha.matter.name(), 70)

      transparent (0.5) {stroke_vertical_line cursor+5,cursor-15,:at=> 325}
      simple_title_generate("Código:", 330, 0)
      show_value(@ficha.matter.code(), 375)

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      simple_title_generate("Natureza:", 10, 5)
      show_value(@ficha.matter.nature(), 64)

      transparent (0.5) {stroke_vertical_line cursor+5,cursor-15,:at=> 325}
      simple_title_generate("Tipo:", 330, 0)
      show_value(@ficha.matter.kind(), 360)

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      simple_title_generate("Pré-requisito:", 10, 5)
      show_value(@ficha.matter.prerequisite(), 85)

      transparent (0.5) {stroke_vertical_line cursor+5,cursor-15,:at=> 225}
      simple_title_generate("Co-requisito:", 230, 0)
      show_value(@ficha.matter.corequisite, 300)

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      simple_title_generate("Modalidade:", 10, 5)
      show_value(@ficha.matter.modality(), 80)

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      transparent (0.5) {stroke_vertical_line cursor,cursor-100,:at=> 225}

      simple_title_generate("Carga Horária", 75, 10)
      simple_title_generate("Códigos", 315, 0)

      simple_title_generate("Semestral Total:", 10, 20)
      show_value(@ficha.matter.total_weekly_workload().to_s + "h", 97)

      simple_title_generate("PD:", 240, 0)
      show_value(@ficha.matter.pd().to_s, 263)

      simple_title_generate("OR:", 300, 0)
      show_value(@ficha.matter.or().to_s, 323)

      simple_title_generate("Anual Total:", 10, 15)
      show_value(@ficha.matter.total_annual_workload().to_s + "h", 74)


      simple_title_generate("LC:", 240, 0)
      show_value(@ficha.matter.lc().to_s, 263)

      simple_title_generate("Modular Total:", 10, 15)
      show_value(@ficha.matter.total_modular_workload().to_s + "h", 87)

      simple_title_generate("CP:", 240, 0)
      show_value(@ficha.matter.cp().to_s, 263)

      simple_title_generate("Semanal:", 10, 15)
      show_value(@ficha.matter.weekly_workload.to_s + "h", 62)

      simple_title_generate("ES:", 240, 0)
      show_value(@ficha.matter.es().to_s, 263)


      move_down 25
      transparent (0.5) { stroke_horizontal_rule }

      title_generate("EMENTA")
      text_box @ficha.matter.menu.to_s, size: 11, :at => [10,cursor]

      move_down (@ficha.matter.menu.to_s.lines.count * 14) + 10
      transparent (0.5) { stroke_horizontal_rule }

      title_generate("PROGRAMA")
      show_value(@ficha.program, 10)

    end

  subtitle_generate

  end

  def record_generate
    header_generate

    bounding_box([50,cursor],:width=>450,:height=>cursor) do
      transparent(0.5){stroke_bounds}

      move_down 5
      text_box "Professor:", size: 11, style: :bold, :at => [10,cursor]
      show_value(@ficha.user.name(), 70)

      move_down 15
      transparent (0.5) { stroke_horizontal_rule }

      title_generate("OBJETIVO GERAL")
      show_value(@ficha.general_objective, 10)

      move_down(count_lines(@ficha.general_objective))

      title_generate("OBJETIVOS ESPECÍFICOS")
      show_value(@ficha.specific_objective, 10)

      move_down(count_lines(@ficha.specific_objective))
      transparent (0.5) { stroke_horizontal_rule }

      title_generate("PROCEDIMENTOS DIDÁTICOS")
      show_value(@ficha.didactic_procedures, 10)

      move_down (count_lines(@ficha.didactic_procedures))
      transparent (0.5) { stroke_horizontal_rule }

      title_generate("FORMAS DE AVALIAÇÃO")
      show_value(@ficha.evaluation, 10)

      move_down (count_lines(@ficha.evaluation))


      if(!new_page(@ficha.basic_bibliography))
        transparent (0.5) { stroke_horizontal_rule }
      end
      title_generate("BIBLIOGRAFIA BÁSICA")
      show_value(@ficha.basic_bibliography, 10)

      move_down (count_lines(@ficha.basic_bibliography))

      new_page(@ficha.bibliography)
      title_generate("BIBLIOGRAFIA COMPLEMENTAR")
      show_value(@ficha.bibliography, 10)

      move_down (count_lines(@ficha.bibliography))



    end

  end

  def new_page(text)
    if(!page_verify(text))
      start_new_page
      move_up 145
      @margem = 0
      header_generate
      transparent (0.5) { stroke_horizontal_rule }

      transparent (0.5) {stroke_vertical_line 593,10,:at=> 0}
      transparent (0.5) {stroke_vertical_line 593,10,:at=> 450}
      transparent (0.5) { stroke_horizontal_line 0, 450, :at=> 10}
      true
    end
    false
  end


  def title_generate(title)
    move_down 15
    text_box title, size: 12, style: :bold, :at => [0,cursor], align: :center
    move_down 20
  end

  def simple_title_generate(title, x, move)
    move_down move
    text_box title, size: 11, style: :bold, :at => [x,cursor]
  end

  def subtitle_generate()
    text_box "Legenda:", size: 11, style: :bold, :at => [50,40]
    legenda = "Conforme Resolução 15/10-CEPE: PD- Padrão LB- Laboratório CP- Campo
    ES- Estágio OR-Orientada"
    text_box legenda, size: 11, :at => [110,40], :height => 50
  end

  def show_value(value, x)
    font("app/fonts/DejaVuSans.ttf") do
      text_box value, size: 11, :at => [x,cursor], :width => 435, :align => :justify
    end
  end

  def count_lines(text)
    ((text.length / 80) + text.lines.count) * 14 + 5
  end

  def count_total_lines(text)
    title = 4
    (((text.length / 80) + text.lines.count) + title) * 14
  end

  def page_verify(text)
    cursor - count_total_lines(text) > 10
  end

  #http://prawnpdf.org/docs/0.11.1/index.html
  #http://prawnpdf.org/manual.pdf

  #https://github.com/prawnpdf/prawn-table
end
