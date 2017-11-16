namespace :utils do

  desc "Import of teachers: lib/users.xlsx"
  task import_users: :environment do

      def pass_generate
        password = ""
        character = ("0".."9").to_a + ("a".."z").to_a
        6.times do |i|
          password << character.sample
        end
        password
      end

      path = "lib/files/users.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      puts "\n============= USERS ============="
      roles = ["teacher", "appraiser", "admin", "secretary", "counselor"]

      (xlsx.sheet(1).last_row - 1).times do |i|
        linha = xlsx.sheet(1).row(i+2)

        name = linha[0]
        email = linha[1]
        role = linha[2]

        if(linha[2].blank?)
            role = 0
        end

        password = pass_generate

        puts "|  #{name}  -  #{email} - #{role} - #{password} "
        user = User.create(name: name, email: email,  role: role, password: password)

        if (role != 3 and role != 0)
          user.add_role "teacher"
          user.add_role roles[role]
        elsif (role == 0)
          user.add_role "teacher"
        else
          user.add_role "secretary"
        end

        user.save
        #if user.save
          #  UserMailer.send_password(user).deliver
        #end
      end
  end

  desc "Inset of teachers and matters"
  task init_2018: :environment do

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

    def find_group(course ,matter, group_name, group_vacances)
      groups = Group.where(course_id: course.id, matter_id: matter.id, name: group_name,
        vacancies: group_vacances, semester_id: Semester.current_semester.id)
      if groups.length == 0
        group = Group.new(course_id: course.id, matter_id: matter.id, name: group_name,
          vacancies: group_vacances, semester_id: Semester.current_semester.id)
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

    path = "lib/files/inserts.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    matters_list = []
    groups_list = []

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
      group_vacances = linha[3]
      group = find_group(course ,matter, group_name, group_vacances)

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
        puts "#{schedule.id}\t#{schedule.day}\t#{schedule.begin}\t#{schedule.duration}"
        add_schedule(group, schedule)
      end

    end

    puts "\n============= MATTERS ============="
    puts "CODE\tMATTER"
    matters_list.sort.each { |matter| puts matter }

    puts "\n============= GROUPS ============="
    puts "ID\tMATTER - NAME\tVAGA\tCOURSE"
    groups_list.each { |group| puts group }


  end
end
