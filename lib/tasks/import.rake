namespace :import do


  desc "Send password"
  task pass: :environment do

    def pass_generate
      password = ""
      character = ("0".."9").to_a + ("a".."f").to_a
      6.times do |i|
        password << character.sample
      end
      password
    end

    def send_to(user)
        password = pass_generate
        user.password = password
        user.save
        puts "User: #{user.name}\tPassword: #{password}"
        UserMailer.send_password(user).deliver
    end


    users = User.all
    users.each do |user|
      if user.id >= 5 && user.id <= 59
        send_to(user)
      end
    end


  end

  desc "Importation of users of lib/files/users.xlsx"
  task users: :environment do

    u = User.create(name: "Professor", email: "prof@prof", password: "123123")
    u.add_role "teacher"

    u = User.create(name: "Admin", email: "adm@adm", password: "123123")
    u.add_role "admin"
    u.add_role "teacher"

    u = User.create(name: "Avaliador", email: "av@av", password: "123123")
    u.add_role "appraiser"
    u.add_role "teacher"

    u = User.create(name: "Secretário", email: "se@se", password: "123123")
    u.add_role "secretary"

    def pass_generate
      password = ""
      character = ("0".."9").to_a + ("a".."f").to_a
      6.times do |i|
        password << character.sample
      end
      password
    end

    path = "lib/files/users_1.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    puts "\n============= USERS ============="
    roles = ["appraiser", "admin", "secretary", "counselor"]

    (xlsx.sheet(1).last_row - 1).times do |i|
      linha = xlsx.sheet(1).row(i+2)

      name = linha[0]
      email = linha[1]
      role = linha[2]
      password = pass_generate.chomp

      user = User.new(name: name, email: email, password: password)
      if user.save
        #  UserMailer.send_password(user).deliver
        puts "|  #{name}  -  #{email} - #{role} - #{password} "

        user.add_role "teacher"
        if(!linha[2].blank?)
          user.add_role roles[(role -1)]
        end
      end


    end
  end

  desc "Importation of courses, matters and groups of lib/files/inserts.xlsx"
  task init: :environment do

    def find_matter(code, name)
      matters = Matter.where(code: code)
      if matters.length == 0
        matter = Matter.new(code: code, name: name, menu: "Ementa...", modality: "Presencial",
        nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum")

        matter.save
      else
        matter = matters.first
      end
      matter
    end

    def find_course(code)
      courses = Course.where(code: code)
      if courses.length == 0
        course = Course.new(code: code, name: "CURSO NÃO ENCONTRADO")
        course.save
      else
        course = courses.first
      end
      course
    end

    def find_group(course ,matter, group_name, group_vacancies)
      groups = Group.where(course_id: course.id, matter_id: matter.id, name: group_name,
        vacancies: group_vacancies, semester_id: Semester.current_semester.id)
      if groups.length == 0
        group = Group.new(course_id: course.id, matter_id: matter.id, name: group_name,
          vacancies: group_vacancies, semester_id: Semester.current_semester.id)
        group.save
      else
        group = groups.first
      end
      group
    end

    def find_schedule(day, start, duration)
      schedules = Schedule.where(begin: start, duration: duration, day: day)
      if schedules.length == 0
        schedule = Schedule.new(begin: start, duration: duration, day: day)
        schedule.save
      else
        schedule = schedules.first
      end
      schedule
    end

    def add_schedule(group, schedule)
      if !group.schedules.include? schedule
        group.schedules.push schedule
      end
    end

    def get_time(input)
      hour = input[0..1].to_i
      minute = input[3..4].to_i
      Time.new(2000, 1, 1, hour, minute, 0, 0)
    end

    def get_duration(s_begin, s_end)
      s_end - (s_begin.hour.hours + s_begin.min.minutes)
    end

    def name_pattern(name)
      words = name.split.map do |peace|
        if @romans.include? peace.upcase
          peace.upcase
        elsif @conectives.include? peace.downcase
          peace.downcase
        else
          peace.capitalize
        end
      end
      words.join(" ")
    end

    @romans = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII"]
    @conectives = ["e", "de", "para", "a", "à", "às", "em"]

    path = "lib/files/courses.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    puts "============= COURSES ============="
    sheet = xlsx.sheet(0)
    puts "ID\tCODE\tNAME\t"
    (sheet.last_row).times do |i|
      linha = sheet.row(i+1)

      code = linha[0]
      name = name_pattern(linha[1].chomp)
      course = Course.new(code: code, name: name)
      course.save

      puts "#{course.id}\t#{code}\t#{name}"
    end

    path = "lib/files/2018-1-Atualizada.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    matters_list = []
    groups_list = []
    new_matters = []

    sheet = xlsx.sheet(0)
    (sheet.last_row() -1).times do |i|
      linha = sheet.row(i+2)

      matter_code = linha[0].chomp.upcase
      matter_name = name_pattern(linha[1].chomp)
      matter = find_matter(matter_code, matter_name)

      matters_item = "#{matter_code}\t#{matter_name}"
      if !matters_list.include? matters_item
        matters_list.push matters_item
      end

      course_code = linha[8].chomp[0 .. -2].to_i
      course = find_course(course_code)

      group_name = linha[2].chomp
      group_vacancies = linha[3]
      group = find_group(course ,matter, group_name, group_vacancies)



      groups_item = "#{group.id}\t#{group.matter.code} - #{group.name}\t#{group.vacancies}\t#{group.course.name}"
      if !groups_list.include? groups_item
        groups_list.push groups_item
      end

      input_schedule = linha[4]
      if !input_schedule.blank?
        line_day = linha[4].first.to_i
        schedule_begin = get_time(linha[5])
        schedule_end = get_time(linha[6])
        schedule_duration = get_duration(schedule_begin, schedule_end)
        schedule = find_schedule(line_day -1, schedule_begin, schedule_duration)
        print "."
        add_schedule(group, schedule)
      end

    end

    puts "\n============= MATTERS ============="
    puts "CODE\tMATTER"
    matters_list.sort.each { |matter| puts matter }

    puts "\n============= GROUPS ============="
    puts "ID\tMATTER - NAME\tVACANCIES\tCOURSE"
    groups_list.each { |group| puts group }



  end


  desc "Importation unite of matters from lib/files/unite_matters.xlsx"
  task unite_matters: :environment do

    path = "lib/files/unite_matters.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    sheet = xlsx.sheet(0)
    (sheet.last_row() -1).times do |i|
      linha = sheet.row(i+2)

      unite_name = linha[0].chomp
      first_matter = linha[1].chomp
      second_matter = linha[2].chomp
      puts "#{unite_name}: #{first_matter} with #{second_matter}"

      unite = UniteMatter.create(name: unite_name)
      unite.matters.push Matter.where(code: first_matter).first
      unite.matters.push Matter.where(code: second_matter).first

    end
  end

  desc "Import of matters data (ficha1)"
  task matters_data: :environment do

    code = "CM005"
    matter = Matter.where(code: code)
    matter = matter.first
    puts matter.class
    puts matter.semester_workload
    puts matter.prerequisite
    matter.semester_workload = 60
    matter.menu = "Matrizes e equações lineares. Espaços vetoriais. Transformações lineares. Operadores e matrizes diagonalizáveis. Espaços com produto interno. Operadores sobre espaços com produto interno. Cônicas. Quádricas."
    matter.basic_bibliography = "DAVID, C. I. - Álgebra Linear e suas Aplicações, Livros Técnicos e Científicos Editora.
    STEVEN, I. L. - Álgebra Linear com Aplicações, LTC, RJ, 1999.
    BOLDRINI et al - Álgebra Linear, Harbra.
    LIMA, E. I - Álgebra Linear, Col. Matemática Universitária. IMPA, CNPq, RJ, 1996."
    matter.save

    code = "CM040"
    matter = Matter.where(code: code)
    matter = matter.first

    matter.semester_workload = 60
    matter.menu = "Ementa variável, focalizando tópicos e fundamentos da matemática I. Abordagem de temas tais como: computabilidade e funções recursivas, análise não-standart, álgebra universal e outros."
    matter.basic_bibliography = "LOVASZ, PELIKAN, VESZETERGOMBI, Matemática Discreta, IMPA, J.J. Rotman, An introduction to abtract algebra."
    matter.save

    code = "CM041"
    matter = Matter.where(code: code)
    matter = matter.first

    matter.semester_workload = 90
    matter.menu = "Função real de uma variável. Derivadas. Integrais. Introdução às equações diferenciais. Tópicos de Cálculo."
    matter.basic_bibliography = "GUIDORIZZI, H. L. - Um Curso de Cálculo, vol. 1, Editora LTC, RJ.
    LEITHOLD, L. - O Cálculo com Geometria Analítica, v.1, Harbra, RJ
    SWOKOWSKI, E. - Cálculo com Geometria Analítica, v.1 e 2. Makron, SP."
    matter.save


  end

end
