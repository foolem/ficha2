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

    code = "CM042"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.menu = "Funções vetoriais de uma variável real. Cálculo diferencial de funções de mais de uma variável. Integração múltipla. Cálculo vetorial. Teoremas de Green, Gauss e Stokes. Tópicos de Cálculo."
    matter.basic_bibliography = "GUIDORIZZI, H. L. - Um Curso de Cálculo, vol. 1, Editora LTC, RJ.
    LEITHOLD, L. - O Cálculo com Geometria Analítica, v.2, Harbra, RJ
    SWOKOWSKI, E. - Cálculo com Geometria Analítica, v.2, Makron, SP."
    matter.save

    code = "CM043"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM042 + CM005"
    matter.semester_workload = 60
    matter.menu = "Séries numéricas e de potências. Equações diferenciais ordinárias. Transformada de Laplace. Tópicos de Cálculo."
    matter.basic_bibliography = "BOYCE, W.E. e DI PRIMA, R.C. - Equações Diferenciais Elementares e Problemas de Valores de Contorno, LTC, RJ.
    BRONSON, R. - Equações Diferenciais. McGraw-Hill.
    KREYSZIG, E. - Matemática Superior, v.1 - LTC, RJ.
    SPIEGEL, M. - Transformada de Laplace. McGraw-Hill."
    matter.save

    code = "CM044"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM043"
    matter.semester_workload = 60
    matter.menu = "Funções de variável complexa. Séries de integrais de Fourier. Equações diferenciais parciais. Tópicos de Cálculo."
    matter.basic_bibliography = "BOYCE, W.E. e DI PRIMA, R.C. - Equações Diferenciais Elementares e Problemas de Valores de Contorno, LTC, RJ.
    KREYSZIG, E. - Matemática Superior, v.1 - LTC, RJ."
    matter.save

    code = "CM045"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Vetores no plano e no espaço. Retas e planos no espaço com coordenadas cartesianas. Translação e rotação de eixos. Curvas no plano. Superfícies. Outros sistemas de coordenadas."
    matter.basic_bibliography = "BOULOS, P. e CAMARGO, I. - Geometria Analítica: um tratamento vetorial. McGraw-Hill, SP.
    STEIBRUCH, A. e WINTERLE, P. - Geometria Analítica, McGraw-Hill."
    matter.save

    code = "CM046"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Operações binárias; Noções de Grupos; Anéis."
    matter.basic_bibliography = "DOMINGUES, H. e IEZZI, G. - Álgebra Moderna Ed. Atual.
    COUTINHO, S. - Números Inteiros e Criptografia RSA. Ed. SBM.
    GONÇALVES, A. - Introdução à Álgebra. Projeto Euclides."
    matter.save

    code = "CM048"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.menu = "Funções de várias variáveis reais. Limite e continuidade. Diferenciabilidade. Derivadas de ordem superior. Máximos e mínimos. Aplicações."
    matter.basic_bibliography = "GUIDORIZZI, H.L. - Um curso de Cálculo, vol.2, LTC Editora, 5ª edição, 2001.
    BORTOLOSSI, H.J. - Cálculo Diferencial a várias variáveis: uma introdução à teoria de Otimização. Edições Loyola, 2003."
    matter.save

    code = "CM053"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Produto interno real e complexo. Forma Racional e de Jordan. Formas bilineares e formas quadráticas."
    matter.basic_bibliography = "HOFFMAN, K. & KUNZE, R. - Álgebra Linear, Edusp, Polígono, São Paulo.
    GELFAND, I.M. Lectures on Linear Algebra, Interscience, New York, 1961.
    BOLDRINO et alii, Álgebra Linear"
    matter.save

    code = "CM068"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM048 ou CM042"
    matter.semester_workload = 60
    matter.menu = "Números complexos. Funções analíticas complexas, Equações de Cauchy-Riemann. Integração Complexa. Fórmula integral de Cauchy. Teoremas de Liouville, de Morera. Teorema dos Resíduos. Séries de Taylor e de Laurent. Aplicações."
    matter.basic_bibliography = "KREIDER, P. - Introdução à análies linear, 1972.
    CHURCHILL, R. V. - Variáveis Complexas e suas aplicações, Edusp, 1975.
    CONWAY, J. B. - Functions of one complex variable, 2nd ed., Springer, 1978."
    matter.save

    code = "CM077"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Curvas, parametrização pelo comprimento de arco, triedro de Frenet-Serrat. Superfícies regulares, funções diferenciáveis, plano tangente. Orientação de superfícies. Primeira e Segunda formas fundamentais. Aplicação normal de Gauss e campos de Vetores. O Teorema 'Egregium' de Gauss. Transporte paralelo e geodésicas. Aplicação exponencial e coordenadas geodésicas. O Teorema de Gauss-Bonet."
    matter.basic_bibliography = "VALLADARES, R. - Introdução à Geometria Diferencial.
    CARMO, Manfredo P. - Geometria Diferencial.
    TENEMBLAT, Ketty, Introdução à Geometria Diferencial."
    matter.save

    code = "CM078"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Espaços métricos. Convergência. Completude. Compacidade. Conexidade. Continuidade. Espaços topológicos."
    matter.basic_bibliography = "J.MUNKRES - Topology. Prentice Hall, 1975.
    E.L. LIMA - Elementos de Topologia Geral. IMPA/SBM, 1993.
    G.F. SIMMONS - Introduction to topology and Modern Analysis. McGraw-Hill, 1963."
    matter.save

    code = "CM081"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Funcionais, variação e suas propriedades. Formalismo Langreangeano, extremos de funcionais e as equações de Euler-Lagrange. Leis de conservação. Formalismo canônico, extremos e as equações de Hamilton-Jacobi. Transformações de Legendre e a relação entre a Langrangeana e a Hamiltoneana. Teoremas de Liouville e Poincaré. Aplicações."
    matter.basic_bibliography = "BRUCE VAN BRUNT, Calculus of Variations, Springer-Verlag, 2004.
    M. GELFANG, S. V. FOMIN, Calculus of Variations, Prentice-Hall, Inc. 1963.
    L.E ELSGOLC, Calculus of Variations, Pergamon Press, 1961.
    M. L. KRASNOV, G. L. MAKARENKO, A. L. KISELEV, Problems and exercises in the Calculus of Variations, Mir Publishers, 1975.
    WEINSTOCK, ROBERT, Calculus of Variations with Applications to Physics and Engeneering, McGraw-Hill, 1987.
    KOMZSIK, LUIS, Applied Calculus of Variations for Engeneers, CRC Press, 2009."
    matter.save

    code = "CM096"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM095"
    matter.semester_workload = 60
    matter.menu = "Equações não lineares. Aritmética de ponto-flutuante. Equações lineares. Interpolação polinomial. Integração numérica."
    matter.basic_bibliography = "STEWART, G. W. - Afternotes on Numerical Analysis, SIAM, 1996.
    RALSTON, A., RABINOWITZ, P. - A First Course in Numerical Analysis, 2nd ed., Dover, 1978.
    BURDENS, R. L., FAIURES, J. D. - Numerical Analysis, Brooks/Cole, 6th ed., 1997."
    matter.save

    code = "CM098"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM043+CM096"
    matter.semester_workload = 60
    matter.menu = "Métodos de passo simples para o problema de valor inicial. Métodos de passo múltiplo para o problema de valor inicial. Controle de passo. Métodos para o problema de valor de contorno. Tópicos em métodos para equações diferenciais ordinárias."
    matter.basic_bibliography = "KINCAID, D., CHENEY E. W. - Numerical Analysis: Mathematics of Scientific Computing, 3nd ed., American Mathematical Society, 2009.
    GOLUB, G., ORTEGA, J. - Scientific computing and differential equations, Academic Press, 1992.
    BURDENS, R. L., FAIRES, J. D. - Análise Numérica, 8th ed., Cengage Learning, 2008.
    KINCAID, D., CHENEY E. W. - Numerical Mathematics and Computing, 6th ed., Thomson Brooks/Cole, 2008."
    matter.save

    code = "CM102"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Introdução às equações diferenciais parciais. Método de separação de variáveis. Separação de variáveis em geometrias cilíndrica e esférica. Aplicações."
    matter.basic_bibliography = "ARFKEN, G. B., WEBER, H. - Mathematical Methods for Physicists, 5th ed., Academic Press, 2000.
    BUTKOV, E. - Física Matemática, Ed. Guanabara, RJ 1978.
    DYKE, P. P. G., An Introduction to Laplace Transforms and Fourier Series, Springer Undergraduate Mathematics Series, Springer-Verlag, UK, 2001(3rd ed., 2004).
    Edmundo Capelas de Oliveira e Matin Tygel - Métodos Motamáticos para Engenharia, SBM, RJ, 2005.
    FIGUEIREDO, D. G. - Análise de Fourier e Equalçoes Diferenciais Parciais, Projeto Euclides, IMPA, 1977.
    JONES, D. S & SLEEMAN, B. D. - Differential Equations and Mathematical Biology.
    MYINT-U, T. - Partial differential equations of Mathematical Physics, Elsevier, 1986.
    Valéria Iório - EDP um curso de graduação, IMPA, RJ, 2010.
    Willian E. Boyce e Richard C. DiPrima - Equações Diferenciais Elementares e Problemas de Contorno, 8a ed., LTC, RJ, 2006."
    matter.save

    code = "CM104"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM043"
    matter.semester_workload = 60
    matter.menu = "Revisão de equações diferenciais ordinárias, lineares de sefybda irden, Sikylçai oir speruesm pontos singulares, método de Frobenius. Funções especiais. Séries de funções ortogonais. Problemas de autovalor."
    matter.basic_bibliography = "E.BUTKOV - Análise de Fourier e Equações Diferenciais Parciais, 4a ed., Projeto Euclides, IMPA 2003.
    E.C.OLIVEIRA, M.TYGEL - Métodos Matemáticos para Engenharia, SBMAC, 2001.
    G.B.ARFKEN, H.WEBER - Mathematical Methods for Physicists, 5a ed., Academic-Press, 2000.
    M.R.SPIEGEL - Theory and problems of Fourier analysis, McGraw-Hill, 1974."
    matter.save

    code = "CM106"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM042 + CM005"
    matter.semester_workload = 60
    matter.menu = "O problema de programação não-linear. Condições de otimalidade para o problema de minimização sem restrições. Convexidade. Os métodos clássicos de descida: Gradiente, Newton, Quase-Newton e Gradiente Conjugado. Condições de otimalidade para o problema de minimização com restrições lineares. Método do Gradiente Projetado. Método das restrições ativas."
    matter.basic_bibliography = "RIBEIRO, A. A. e KARAS, E. W. - Um curso de otimização.
    FRIEDLANDER, A. - Elementos de programação não-linear, Editora da Unicamp, 1994.
    LUENBERGER, D. G. - Linear and nonlinear programming, Addison-Wesley, 1989.
    IZMAILOV, A. SOLODOV, M. - Otimização, vol.1 2009 e vol.2 2007, IMPA."
    matter.save

    code = "CM111"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.prerequisite = "CM095"
    matter.semester_workload = 60
    matter.menu = "Integral de Riemann: teorema fundamental do cálculo, mudança de variáveis. Teoremas do valor médio para integrais. Integrais impróprias. Sequências e séries de funções. Funções analíticas reais. Teorema da aproximação de Weierstrass. Teorema de Arzelà-Ascoli."
    matter.basic_bibliography = "T.APOSTOL - Mathematical Analysis. Addison Wesley Pub, Co. 1974.
    E.L.LIMA - Curso de Análise, vol.1. Projeto Euclides, IMPA.
    W.RUDIN - Principles of Mathematical Analysis. 3a. Ed. McGraw-Hill, 1976."
    matter.save

  end

end
