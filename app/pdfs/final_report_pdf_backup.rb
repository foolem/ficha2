class FinalReportPdf < Prawn::Document

  include GroupsHelper

  def initialize()
    super(top_margin: 20)
    @margem = 50
    @number = 0

    header_generate
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

    move_down 28
    text  "RELAÇÃO DE TURMAS", size: 12, style: :bold, align: :center
    move_down 22

    transparent (0.5) { stroke_horizontal_rule }
    transparent (0.5) {stroke_vertical_line 592,17,:at=> 0}
    transparent (0.5) {stroke_vertical_line 592,17,:at=> 540}
    transparent (0.5) { stroke_horizontal_line 0, 540, :at=> 17}

    @number+=1
   text_box  @number.to_s, size: 11, :at => [530,11]
  end


  def record_generate

    table_header

    current_groups.each_with_index do |group, i|
      move_down 7

      owner = group.ficha.blank? ? " " : group.ficha.user.name
      text_box  owner , size: 12, :at => [20, cursor]
      text_box  group.code_with_group_show , size: 12, :at => [360, cursor]
      if ((i+1) % 25) == 0
        puts i
        start_new_page
        header_generate
        table_header
      else
        move_down 15
        transparent (0.5) { stroke_horizontal_line 0, 540, :at=>  cursor}
      end

    end

    move_down 15
  end

  def table_header
    move_down 7

    text_box "Docente", style: :bold, size: 12, :at => [20, cursor]
    text_box "Turma", style: :bold, size: 12, :at => [360, cursor]
    text_box "Sala", style: :bold, size: 12, :at => [480, cursor]
    move_down 15
    transparent (0.5) { stroke_horizontal_line 0, 540, :at=>  cursor}

  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end

end
