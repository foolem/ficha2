class ResultPdf < Prawn::Document

  def initialize()
    super(top_margin: 20)
    @ficha = Ficha.first
    @user = User.find 58
    @availability = @user.availabilities.first
    @margem = 50
    @number = 0
    record_generate
  end

  def default_array
    column = {}
    t = Time.parse("2000/01/01 7:30")
    while t.hour != 22
      column["#{t.hour}:#{t.min}"] = false
      t += 1.hours
    end
    column
  end

  def column_day(user, day)
    schedules = Schedule.find_by_users_and_day(user, day)

    column = default_array
    schedules.each do |sch|
      start = sch.begin
      finish = sch.begin + sch.duration.hour.hours
      new_start = start

      while new_start != finish
        column["#{new_start.hour}:#{new_start.min}"] = true;
        new_start += 1.hours
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
    t = Time.parse("2000/01/01 7:30")

    columns = get_columns(user)

    while t.hour != 22
      current_row = []
      current_row.push("#{t.strftime("%H:%M")} - #{(t + 1.hours).strftime("%H:%M")}")

      [1,2,3,4,5].each do |day|
        if columns[day - 1]["#{t.hour}:#{t.min}"]
          current_row.push("x")
        else
          current_row.push("")
        end
      end
      all_rows.push(current_row)
      t += 1.hours
     end
     all_rows
  end

  def header_generate
    move_down 5
    text  @user.name.upcase, size: 12, style: :bold, align: :center
    text  @user.email.downcase, size: 11, align: :center
    move_down 5

    transparent (0.5) { stroke_horizontal_rule }
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 0}
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 540}
    transparent (0.5) { stroke_horizontal_line 0, 540, :at=> 17}

    @number+=1
    text_box  @number.to_s, size: 11, :at => [530,11]
  end

  def record_generate

    header_generate

    move_down 5
    text_box "Indisponibilidades", size: 12, style: :bold, :at => [0,cursor], align: :center
    move_down 15
    table get_rows, cell_style: {height: 19, size: 10, align: :center}, column_widths: [100,80,80, 80,80,80,80],position: 20
    move_down 5

    simple_title_generate "Justifcativa: ", 20, 5
    bounding_box([95, cursor], :width => 425) do
      text @availability.comments
    end

    move_down 5
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate "Preferências: ", 20, 5
    bounding_box([95, cursor], :width => 500) do
      font_size(12) { text "1º: #{get_preference(@availability.preference_first)}" }
      font_size(12) { text "2º: #{get_preference(@availability.preference_second)}" }
      font_size(12) { text "3º: #{get_preference(@availability.preference_third)}" }
    end

    move_down 5
    transparent (0.5) { stroke_horizontal_rule }

    #outras_escolhas

    move_down 5
    text_box "Escolhas", size: 12, style: :bold, :at => [0,cursor], align: :center
    move_down 15
    table [
      ["Opção", "Disciplina", "Horário"],
      [1, "Álgebra Linear: CM005", "2a4a 15:30 - 17:30"],
      [2, "Álgebra Linear: CM005", "2a4a 15:30 - 17:30"],
      [3, "Álgebra Linear: CM005", "2a4a 15:30 - 17:30"],
      [4, "Álgebra Linear: CM005", "2a4a 15:30 - 17:30"]],
      column_widths: [50, 200, 250], cell_style: {padding: 5, size: 10, align: :center},position: 20

    move_down 10
    transparent (0.5) { stroke_horizontal_rule }

    simple_title_generate "Comentários: ", 20, 5
    bounding_box([95, cursor], :width => 425) do
      text @availability.general_comments, size: 12
    end

    move_down 5
  end

  def outras_escolhas

    move_down 5
    text_box "Escolhas", size: 12, style: :bold, :at => [0,cursor], align: :center
    move_down 15

    bounding_box([95, cursor], :width => 425) do
      font_size(12) { text "1º: CM107 A (Otimização II, 2ª4º 15:30)" }
    end
    move_down 2
    bounding_box([95, cursor], :width => 425) do
      font_size(12) { text "2º: CM107 A (Otimização II, 2ª4º 15:30)" }
    end
    move_down 2
    bounding_box([95, cursor], :width => 425) do
      font_size(12) { text "3º: CM107 A (Otimização II, 2ª4º 15:30)" }
    end
    move_down 2
    bounding_box([95, cursor], :width => 425) do
      font_size(12) { text "4º: CM107 A (Otimização II, 2ª4º 15:30)" }
    end
    move_down 2
    bounding_box([95, cursor], :width => 425) do
      font_size(12) { text "5º: CM107 A (Otimização II, 2ª4º 15:30)" }
    end

  end

  def title_generate(title)

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

  def get_preference(input)
    if input.blank?
      return
    end

    ["Concentrar minhas aulas pela manhã",
    "Concentrar minhas aulas à tarde",
    "Concentrar minhas aulas à noite",
    "Não dar aulas às 7:30",
    "Não dar aulas à noite",
    "Concentrar todas minhas aulas em 2 ou 3 dias da semana",
    "Ficar apenas com disciplinas iguais","Dar duas aulas em sequência",
    "Não dar duas aulas em sequência"][input]
   end

  #http://prawnpdf.org/docs/0.11.1/index.html
  #http://prawnpdf.org/manual.pdf

  #https://github.com/prawnpdf/prawn-table
end
