namespace :utils do

  desc "Inset of records"
  task setup_record: :environment do

    def randomize_semester()
      return  Random.rand(2) + 1
    end

    def randomize_year()
      random = Random.rand(3)
      operator = Random.rand(2)

      year = Time.now.year
      if(operator == 1)
        year-= random
      else
        year += random
      end

      return year
    end

    def create_fichas(quantity, status, appraisal)

      matter = Matter.last
      teacher = User.where(role: 0).last


      quantity.times do |i|

        semester = randomize_semester
        year = 2017
        if(status == "Aprovado")
          year = randomize_year
        end
        name = Faker::Name.name
        matter_id = Random.rand(matter.id - 1)
        teacher_id = Random.rand(teacher.id - 1)

        Ficha.create(matter_id: matter_id + 1, user_id: teacher_id + 1, general_objective: "Desenvolver habilidades em...",
        specific_objective: "Aprender x\nEntender y\nInterpretar z", status: status, appraisal: appraisal,
        year: year, semester: semester)

        puts ("Criando ficha: #{matter_id + 1}, #{teacher_id + 1}")

      end
    end

    create_fichas(20, "Editando", "")
    create_fichas(20, "Enviado", "")
    create_fichas(20, "Reprovado", "Bibliografia fora das normas")
    create_fichas(20, "Aprovado", "")

  end


  desc "Inset of teachers"
  task setup_teachers: :environment do

      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      (xlsx.sheet(1).last_row - 1).times do |i|
        linha = xlsx.sheet(1).row(i+2)

        puts "|  #{linha[0]}  -  #{linha[1]} |"
        name = linha[0]
        email = linha[1]

        User.create(name: name, email: email, password: "123123",  role: 0)
      end

  end

  desc "Inset of matters"
  task setup_matters: :environment do

      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      (xlsx.sheet(0).last_row - 1).times do |i|
        linha = xlsx.sheet(0).row(i+2)

        puts "|  #{linha[0]}  -  #{linha[1]} |"
        code = linha[0]
        name = linha[1]

        Matter.create(code: code, name: name, menu: "Exemplo", modality: "Presencial",
        nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum")

      end

  end


end
