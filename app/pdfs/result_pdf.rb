class ResultPdf < Prawn::Document


  def default_array
    column = {}
    t = Time.parse("2000/01/01 7:00")
    while t.hour != Time.parse("2000/01/01 22:00").hour
      t += 30.minutes
      column["#{t.hour}:#{t.min}"] = false
    end
    column
  end

  def column_day(user, day)
    schedules = Schedule.find_by_users_and_day(user, day)

    column = default_array
    schedules.each do |sch|
      start = sch.begin
      finish = sch.begin + sch.duration.hour.hours + sch.duration.min.minutes
      new_start = start

      while new_start != finish
        column["#{new_start.hour}:#{new_start.min}"] = true;
        new_start += 30.minutes
      end

    end

    column
  end

  def header
    ["Horário",  "Segunda",  "Terça",  "Quarta",  "Quinta",  "Sexta"]
  end

  def get_columns(user)
    columns = []
    [1,2,3,4,5].each do |day|
      columns.push(column_day(user, day))
    end
    columns
  end

  def get_rows
    user = User.find(58)
    all_rows = []
    all_rows.push(header)
    t = Time.parse("2000/01/01 7:00")

    columns = get_columns(user)

    while t.hour != Time.parse("2000/01/01 22:00").hour
      current_row = []
      current_row.push("#{t.strftime("%H:%M")} - #{(t + 30.minutes).strftime("%H:%M")}")

      [1,2,3,4,5].each do |day|
        if columns[day - 1]["#{t.hour}:#{t.min}"]
          current_row.push("x")
        else
          current_row.push("")
        end
      end

      all_rows.push(current_row)
      t += 30.minutes
     end
     all_rows
  end

  def initialize()
    super(top_margin: 20)
    @ficha = Ficha.first
    @margem = 50
    @number = 0
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

  def record_generate

    header_generate

    table get_rows

    user = User.find(58)

    move_down 5
    text_box "Professor:", size: 11, style: :bold, :at => [10,cursor]
    show_value(@ficha.user.name(), 70)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Disciplina:", 10, 5)
    show_value(@ficha.group.matter.name(), 70)

    transparent (0.5) {stroke_vertical_line cursor+5,cursor-55,:at=> 348}
    simple_title_generate("Código:", 358, 0)
    show_value(@ficha.group.matter.code(), 403)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Turma:", 10, 5)
    show_value(@ficha.group.name, 50)

    simple_title_generate("Semestre:", 358, 0)
    show_value(@ficha.group.semester.semester_with_year, 413)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    transparent (0.5) {stroke_vertical_line cursor-20,cursor,:at=> 174}

    simple_title_generate("Natureza:", 10, 5)
    show_value(@ficha.group.matter.nature(), 64)

    simple_title_generate("Modalidade:", 187, 0)
    show_value(@ficha.group.matter.modality(), 257)


    transparent (0.5) {stroke_vertical_line cursor+5,cursor+5,:at=> 325}

    simple_title_generate("Tipo:", 358, 0)
    show_value(@ficha.group.matter.kind(), 388)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate("Pré-requisito:", 10, 5)
    show_value(@ficha.group.matter.prerequisite(), 85)

    transparent (0.5) {stroke_vertical_line cursor+5,cursor-15,:at=> 275}

    simple_title_generate("Co-requisito:", 280, 0)
    show_value(@ficha.group.matter.corequisite, 350)

    move_down 15
    transparent (0.5) { stroke_horizontal_rule }

    transparent (0.5) {stroke_vertical_line cursor,cursor-100,:at=> 275}

    simple_title_generate("Carga Horária", 100, 10)
    simple_title_generate("Códigos", 390, 0)

    simple_title_generate("Semestral Total:", 10, 20)
    show_value(@ficha.group.matter.total_weekly_workload().to_s + "h", 97)

    simple_title_generate("Padrão:", 290, 0)
    show_value(@ficha.group.matter.pd().to_s, 333)

    simple_title_generate("Orientada:", 380, 0)
    show_value(@ficha.group.matter.or().to_s, 437)

    simple_title_generate("Anual Total:", 10, 15)
    show_value(@ficha.group.matter.total_annual_workload().to_s + "h", 74)


    simple_title_generate("Laboratório:", 290, 0)
    show_value(@ficha.group.matter.lc().to_s, 357)

    simple_title_generate("Modular Total:", 10, 15)
    show_value(@ficha.group.matter.total_modular_workload().to_s + "h", 87)

    simple_title_generate("Campo:", 290, 0)
    show_value(@ficha.group.matter.cp().to_s, 333)

    simple_title_generate("Semanal:", 10, 15)
    show_value(@ficha.group.matter.weekly_workload.to_s + "h", 62)

    simple_title_generate("Estágio:", 290, 0)
    show_value(@ficha.group.matter.es().to_s, 336)


    @counter = 25
    title_generate("EMENTA")
    new_page(@ficha.group.matter.menu.to_s, 10)

    move_down 5
    title_generate("PROGRAMA")
    new_page(@ficha.program, 10)

    title_generate("OBJETIVO GERAL")
    new_page(@ficha.general_objective, 10)

    title_generate("OBJETIVOS ESPECÍFICOS")
    new_page(@ficha.specific_objective, 10)

    title_generate("PROCEDIMENTOS DIDÁTICOS")
    new_page(@ficha.didactic_procedures, 10)

    title_generate("FORMAS DE AVALIAÇÃO")
    new_page(@ficha.evaluation, 10)

    title_generate("BIBLIOGRAFIA BÁSICA")
    new_page(@ficha.basic_bibliography, 10)

    title_generate("BIBLIOGRAFIA COMPLEMENTAR")
    new_page(@ficha.bibliography, 10)

  end

  def title_generate(title)
    move_down(@counter)
    if(cursor < 85)
      start_new_page
      header_generate
      move_down(5);
    else
      transparent (0.5) { stroke_horizontal_rule }
    end

    move_down 15
    text_box title, size: 12, style: :bold, :at => [0,cursor], align: :center
    move_down 20
  end

  def simple_title_generate(title, x, move)
    move_down move
    text_box title, size: 11, style: :bold, :at => [x,cursor]
  end

  #apagar
  def subtitle_generate()
    text_box "Legenda:", size: 11, style: :bold, :at => [50,40]
    legenda = "Conforme Resolução 15/10-CEPE: PD- Padrão LB- Laboratório CP- Campo
    ES- Estágio OR-Orientada"
    text_box legenda, size: 11, :at => [110,40], :height => 50
  end

  def show_value(value, x)
    if(!value.blank?)
      font("app/fonts/DejaVuSans.ttf") do
        text_box value, size: 10, :at => [x,cursor], :width => 520, :align => :justify
      end
    end
    end

  def new_page(text, x)
    if !text.blank?
      count_lines(text)
      if(!@content[1].blank?)
        show_value(@content[0], x)
        start_new_page
        header_generate
        move_down(5);
        show_value(@content[1], x)
        true
      else
        show_value(@content[0], x)
        false
      end
    else
      false
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

      if((cont >= 90 and l == ' ') or l == "\n" or cont >= 95)
        result += 1
        cont = 0

        if( (cursor - ((result * 13) + 5)) < 30 ) and text2.blank?
          text2 = text[0, i-1]
          text3 = text[i, text.length-1]
          result = 1
        end

      end
    end
    if(cont > 0)
      result += 1
    end

    if(text2.blank? and text3.blank?)
      text2 = text
    end

    @content << text2
    @content << text3
    @counter = result * 13 + 5
    @counter

  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end


  #http://prawnpdf.org/docs/0.11.1/index.html
  #http://prawnpdf.org/manual.pdf

  #https://github.com/prawnpdf/prawn-table
end
