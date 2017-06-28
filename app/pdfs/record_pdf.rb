class RecordPdf < Prawn::Document

  def initialize(ficha)
    super(top_margin: 20)
    @ficha = ficha
    @margem = 50
    @number=0
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

    transparent (0.5) { stroke_horizontal_rule }
    transparent (0.5) {stroke_vertical_line 592,17,:at=> 0}
    transparent (0.5) {stroke_vertical_line 592,17,:at=> 540}
    transparent (0.5) { stroke_horizontal_line 0, 540, :at=> 17}

    @number+=1
    text_box  @number.to_s, size: 11, :at => [530,11]


  end

  def matter_generate

    header_generate


    move_down 5
    text_box "Professor:", size: 11, style: :bold, :at => [10,cursor]
    show_value(@ficha.user.name(), 70)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Disciplina:", 10, 5)
    show_value(@ficha.matter.name(), 70)

    transparent (0.5) {stroke_vertical_line cursor+5,cursor-55,:at=> 348}
    simple_title_generate("Código:", 358, 0)
    show_value(@ficha.matter.code(), 403)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Turma:", 10, 5)
    show_value(@ficha.team, 50)

    simple_title_generate("Semestre:", 358, 0)
    show_value(getSemester(@ficha), 413)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    transparent (0.5) {stroke_vertical_line cursor-20,cursor,:at=> 174}

    simple_title_generate("Natureza:", 10, 5)
    show_value(@ficha.matter.nature(), 64)

    simple_title_generate("Modalidade:", 187, 0)
    show_value(@ficha.matter.modality(), 257)


    transparent (0.5) {stroke_vertical_line cursor+5,cursor+5,:at=> 325}

    simple_title_generate("Tipo:", 358, 0)
    show_value(@ficha.matter.kind(), 388)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Pré-requisito:", 10, 5)
    show_value(@ficha.matter.prerequisite(), 85)

    transparent (0.5) {stroke_vertical_line cursor+5,cursor-15,:at=> 275}

    simple_title_generate("Co-requisito:", 280, 0)
    show_value(@ficha.matter.corequisite, 350)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    transparent (0.5) {stroke_vertical_line cursor,cursor-100,:at=> 275}

    simple_title_generate("Carga Horária", 100, 10)
    simple_title_generate("Códigos", 390, 0)

    simple_title_generate("Semestral Total:", 10, 20)
    show_value(@ficha.matter.total_weekly_workload().to_s + "h", 97)

    simple_title_generate("Padrão:", 290, 0)
    show_value(@ficha.matter.pd().to_s, 333)

    simple_title_generate("Orientada:", 380, 0)
    show_value(@ficha.matter.or().to_s, 437)

    simple_title_generate("Anual Total:", 10, 15)
    show_value(@ficha.matter.total_annual_workload().to_s + "h", 74)


    simple_title_generate("Laboratório:", 290, 0)
    show_value(@ficha.matter.lc().to_s, 357)

    simple_title_generate("Modular Total:", 10, 15)
    show_value(@ficha.matter.total_modular_workload().to_s + "h", 87)

    simple_title_generate("Campo:", 290, 0)
    show_value(@ficha.matter.cp().to_s, 333)

    simple_title_generate("Semanal:", 10, 15)
    show_value(@ficha.matter.weekly_workload.to_s + "h", 62)

    simple_title_generate("Estágio:", 290, 0)
    show_value(@ficha.matter.es().to_s, 336)


    move_down 25
    transparent (0.5) { stroke_horizontal_rule }

    title_generate("EMENTA")
    new_page(@ficha.matter.menu.to_s, 10)
    #show_value(@ficha.matter.menu.to_s, 10)

    puts @counter/12 - 5
    move_down(@counter)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    title_generate("PROGRAMA")
    new_page(@ficha.program, 10)
  #show_value(@ficha.program, 10)

  end

  def record_generate
    header_generate

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

    title_generate("BIBLIOGRAFIA BÁSICA")
    show_value(@ficha.basic_bibliography, 10)

    move_down (count_lines(@ficha.basic_bibliography))

    title_generate("BIBLIOGRAFIA COMPLEMENTAR")
    show_value(@ficha.bibliography, 10)

    move_down (count_lines(@ficha.bibliography))


  end

  def new_page(text, x)
    page_verify(text)
    if(!@content[0].blank?)

      show_value(@content[0], x)
      start_new_page
      header_generate
      puts "NEW PAGE"
      move_down(5);
      show_value(@content[1], x)
      true
    else
      show_value(@content[1], x)
      false
    end
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
      text_box value, size: 10, :at => [x,cursor], :width => 520, :align => :justify
    end
  end

  def count_total_lines(text)
    title = 4
    (text.lines.count + title) * 14
  end

  def  count_lines(text)
    cont = 0
    result = 0
    text2 = ""
    text3 = ""

    text2_cont = 0
    @content = []

    for i in 0..text.length - 1
      l = text[i]
      cont += 1

      if((cont >= 90 and l == ' ') or l == "\n")
        result += 1
        cont = 0

        if( (cursor - ((result * 12) + 5)) < 18 ) and text2.blank?
          puts "Achei a letra de corte. Posição string [#{i}]"
          text2 = text[0, i-1]
          text3 = text[i, text.length-1]
          result = 1
        end

      end
    end
    if(cont > 0)
      result += 1
    end

    @content << text2
    @content << text3
    @counter = result * 12 + 5
    @counter

  end

  def page_verify(text)
    cursor - count_lines(text) > 17
  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end


  #http://prawnpdf.org/docs/0.11.1/index.html
  #http://prawnpdf.org/manual.pdf

  #https://github.com/prawnpdf/prawn-table
end
