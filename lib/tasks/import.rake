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

    code = "CM078"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.menu = "Equações e inequações. Funções. Funções polinomiais. Funções exponencial, logarítmica e trigonométricas. Funções racionais. Gráfico de funções. Noções de limite e de sequências."
    matter.basic_bibliography = "ÁVILA, G. - Introdução à Análise Matemática, Editora Edgard Blucher Ltda., 1993.
    CARNEIRO, V. C. - Funções Elementares, Editora da UFPR - 1993.
    FLEMMING, D. M. & GONÇALVES, M. B. - Cálculo A, Makron Books 1992.
    GUIDORIZZI, H. L. - Um Curso de Cálculo, Livros Técnicos e Científicos, 1987.
    HOFMANN, L. D. - Cálculo - Um curso moderno e suas aplicações, vol. 1, Editora LTC.
    IEZZI, G. E outros - Fundamentos da Matemática Elementar, Atual Editora.
    LAGES LIMA, E. E outros - A matemática do Ensino Médio, vol.1 e 3, Coleção do Professor de Matemática.
    MACHADO, N. L, ANTUNES, F. C., TROTTA, F. - Matemática por assunto, vol.1, 3 e 8, Editora Scipione.
    MONTEIRO, L. H. J. - Iniciação às Estruturas Algébricas, G. E. E. M., São Paulo.
    SIMMONS, G. F. - Cálculo com Geometria Analítica, McGraw-Hill, 1985.
    SOUZA, J. C. M. & LOPES, M. L. M. & CARVALHO, M. S. - Fundamentação da Matemática Elementar, Editora Campus, RJ.
    SPIVACK, M. - Calculus. Publish or Perish, Houston, 1994.
    ZILL, D. - DOWAR, J. - Basic Mathematics for Calculus, McGraw-Hill, New York, 1994.
    Revista do Professor de Matemática - todos os números, SBM."
    matter.save

    code = "CM119"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.menu = "Retas e pontos no plano com coordenadas cartesianas. Vetores no plano e no espaço. Retas e planos no espaço com coordenadas cartesianas. Translação e rotação de eixos. Curvas no plano. Superfícies. Outros sistemas de coordenadas."
    matter.basic_bibliography = "BOULOS, P. CAMARGO, I. - Geometria Analítica: um tramamentos vetorial, McGraw-Hill, SP.
    LAGES LIMA, E. - Coordenadas no Plano, 2ª edição, Coleção do Professor de Matemática.
    LAGES LIMA, E. - Coordenadas no Espaço, Coleção do Professor de Matemática.
    LAGES LIMA, E. - A matemática no Ensino Médio, vol. 3, Coleção do Professor de Matemática.
    STEINBRUCH, A., WiNFERLE, P. - Geometria Analítica, McGraw-Hill
    WINTERLE, P. - Vetores e Geometria Analítica, Makron Books, 2000."
    matter.save

    code = "CM121"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Apliações das equações diferenciais de primeira e segunda ordem. Algumas aplicações de equações não lineares. Sistemas de equações diferenciais."
    matter.basic_bibliography = "W.E.BOYCE, ET AL - Equações diferenciais elementares e problemas de valores de contorno. Ed.LTC, 2001.
    E.KREYSZIG - Advanced Engineering Mathematics, Ed. John Wiley & Sons, 1999.
    D.G.FIGUEIREDO, ET AL. - Equações Diferenciais Aplicadas. Ed. IMPA, 1997.
    C.M.BENDER, ET AL. - Advanced Mathematical Methods for Scientists and Engineers. Ed. McGraw-Hill, 1978."
    matter.save

    code = "CM122"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Princípios da indução finita e da boa ordenação, construção dos números naturais e inteiros. Relações de Equivalência. Supremo e ínfimo. Racionais e reais, sequências e séries de números reais, expansão decimal. Funções Contínuas."
    matter.basic_bibliography = "G. ÁVILA - Introdução à análise matemática. Editora Edgard Blucher, 1999.
    G. ÁVILA - Análise matemática para licensiatura, Editora Edgard Blucher, 2006.
    R.G. BARTLE and D.R. SHERBERT - Introduction to real Analysis. John Wiley & Sons, 2000.
    D.G.FIGUEIREDO - Análise I. Editora LTC, 1996.
    E.L. LIMA - Análise real. Coleção Matemática Universitária, IMPA, 1989."
    matter.save

    code = "CM124"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Apresentação Axiomática dos inteiros. Divisibilidade. Congruências. Números algébricos e transcendentes. Representações decimais finitas e infinitas. Aplicações."
    matter.basic_bibliography = "DOMINGUES, H. H. - Fundamentos de Aritmética. Editora Atual.
    HEFEZ, A. - Elementos de Aritmética. Editora da Sociedade Brasileira de Matemática."
    matter.save

    code = "CM126"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Grupos, subgrupos e homomorfismos. Grupos de permutações. Grupos abelianos finitamente gerados. Ações de grupos e aplicações à contagem. Extensões algébricas. Grupo de Galois de uma extensão. Correspondência de Galois e suas aplicações. Grupos solúveis Resolubilidade de equações por radicais. Aplicações."
    matter.basic_bibliography = "Adilson Gonçalves - Introdução à Álgebra. Projeto Euclides, RJ, IMPA, 1979.
    Arnaldo Garcia e Yves Lequain - Álgebra: um curso de introdução. Projeto Euclides, RJ, IMPA, 1988.
    John Fraleigh - A First Course in Abstract Agebra, USA: Addison-Wesley Pub. Comp., 1994."
    matter.save

    code = "CM133"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Conteúdos do ensino médio e sua relação com a matemática do ensino superior. Pensamento algébrico, geométrico, analítico e probabilístico em situações de ensino. Planejamento e simulação de aulas."
    matter.basic_bibliography = "Almouloud, Saddo Ag. - Fundamentos da didática da matemática, Curitiba, Editora UFPR.
    BRASIL, Parametro curricular nacional ensino médio, Parte III Ciencias da Naturea e Matemática e suas tecnologias, 2000. Disponível em: http://portal.mec.gov.br/seb/arquivos/pdf/ciencian.pdf
    COXFORD, A., SHULTE, A. - As idéias da álgebra. Traduzido por Hygino H. Domingues. SP, Atual, 1995.
    FIORENTINI, Dario. MIORIM, Maria Ângela. MIGUEL, Antonio - Contribuição para um Repensar... a Educação Algébrica Elementar. Pro-Posições, v. 4, nº 1[10], p. 78-91, 1993."
    matter.save

    code = "CM142"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Ementa variável, focalizando tópicos de História da Matemática."
    matter.basic_bibliography = "CIRCE MARY SILVA DA SILVA - No paraíso dos símbolos: surgimento da Lógica e Teoria dos Conjuntos no Brasil. In: Filosofia, Lógica e Existência (Luiz Carlos Bombassaro e Jayme Paviani, Org.). Caxias do Sul: EDUCS, 1997, p.141-168.
    GILLES GASTON GRANGER - Os imaginários. In:O irracional (cap.2), SP: Ed. UNESP, 2002, p.53-81.
    HERBERT MEHRTENS, HENK BOS E IVO SCHNEIDER. Social History of Nineteenth Century Mathematics. Boston: Birkhauser, 1981.
    HOWARD EVES - Geometria no euclidiana, In: Estudio de las Geometrías, vol I (Cap. VII). México: UTEHA, 1969, p.319-359.
    HOWARD EVES - Fundamentos de la geometria. In: Estudio de las Geometrías, vol I (Cap. VIII). México: UTEHA, 1969, p.360-421.
    HOWARD EVES. La geometría y la teoría de grupos. In: Estudio de las Geometrías, vol I (Cap. VIII). México: UTEHA, 1969, p.130-164.
    Jean Dieudonné - A Formação da Matemátiac Contemporânea. Lisboa: Pub. Dom Quixote, 1990.
    JEREMY GRAY - The nineteenth-century revolution in mathematical ontology. In: Revolutions in Mathematics (D. Gillies Ed.) Oxford: Oxford Univ Press, 1995, p.226-248.
    JOÃO CARLOS GILLI MARTINS. Sobre Revoluções Científicas na Matemática. Tese de Doutorado. Rio Claro: UNESP, 2005
    JOSÉ SOUZA PINTO. O Cálculo e os Infinitésimos. In: Métodos infinitesimais de Análise Matemática (Apêndice A). Lisboa: Fund. Calouste Gulbenkian, 2000, p.335-348.
    LUCAS BUNT, PHILLIP JONES E JACK BEDIENT - The Historical Roots of Elementary Mathematics. New York: Dover Pub, 1976.
    WILLIAM DUNHAM - La no enumerabilidad del continuum. In: Viaje através de los Gênios (Cap.11). Madri: Ed. Pirámide, 1993, p.311-337
    WILLIAM DUNHAM - Cantor y el reino de lo transfinito. In: Viaje através de los Gênios (Cap. 12) Madri: Ed. Pirámide, 1993, p.338-358"
    matter.save

    code = "CM201"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Funções. Derivadas. Aplicações do cálculo diferencial. Integrais. Séries."
    matter.basic_bibliography = "GUIDORIZZI, H. L. - Curso de Cálculo, vol. 1, LTC.
    SPIVAK, M. - Cálculus210"
    matter.save

    code = "CM202"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.menu = "Noções elementares de topologia do Rn. Cálculo diferencial de funções de mais de uma variável. Noções elementares de equações diferenciais ordinárias."
    matter.basic_bibliography = "GUIDORIZZI, H. L. - Um Curso de Cálculo, vol1 e 2, Ed. LTC, RJ.
    LEITHOLD, L. - O Cálculo com Geometria Analítica, v.1 e 2, Harbra, RJ.
    SWOKOWSKI, E. Cálculo com Geometria Analítica, v.1 e 2, Makron, SP.
    LIMA, ELON L - Espaçoes Métricos, Projeto Euclides, IMPA.
    RUDIN, W. - Principles of Mathematical Analysis, McGraw-Hill."
    matter.save

    code = "CM300"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.pd = 4
    matter.menu = "Números reais e expressões algébricas. Funções de uma variável real. Gráficos. Funções do primeiro e do segundo graus. Função raiz quadrada. Funções polinomiais. Funções exponenciais e logarítmicas. Funções trigonométricas. Derivadas e taxas de variação."
    matter.basic_bibliography = "E. Connaly, D. Hughes-Hallet, A.M. Gleason, P.Cheifetz, P.F. Lock, K.R. Rhea e C.E. Swenson, Funções para Modelar Variações: Uma Preparação para o Cálculo, 3ª edição, LTC, SP, 2009.
    D. Kennedy, G.D Foley e F. Demana, Pré-cálculo, 2ª edição, Pearson, SP, 2013.
    J. Stewart - Cálculo. Vol 1, 7ª edição, Cengage Learning, SP, 2013."
    matter.bibliography = "V.Z. Medeiros, L.M.O. da Silva, M.A.S.C, Machado e A. Machado, Pré-cálculo, 3ª edição, Cengage Learning, São Paulo, 2013
    A.A. Dornelles Filho, A.M Adami e M.M Lorandi, Pré-Cálculo, 1ª edição, Bookman, Porto Alegre, 2015."
    matter.save

    code = "CM301"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.pd = 4
    matter.menu = "Noções básicas de limite e continuidade. Noções de derivada e reta tangente. Regras básicas de derivação. Máximos e mínimos. Noções de integral e técnicas básicas de integração. Noções de equações diferenciais ordinárias."
    matter.basic_bibliography = "HUGHES-HALLET, D. et al - Cálculo Aplicado, Ed. LTC, RJ, 2012.
    HUGHES-HALLET, D. et al - Cálculo e Aplicações, Edgard Blucher, SP, 1999.
    HUGHES-HALLET, D. et al - Cálculo a uma e várias variáveis, Ed. LTC, RJ, 2011.
    SWOKOWSKI, E. - O cálculo com geometria analítica, vol. 1, 2ª ed., Makron Books, SP, 1995."
    matter.bibliography = "ANTON, H. - Cálculo: Um Novo Horizonte, vol.1 6ª ed., Porto Alegre, Bookman, 2000.
    BATSCHELET, E. - Introdução à Matemática para Biocentristas, Interciência, RJ, 1978.
    THOMAS, G. B. - Cálculo vol.1, 11ª ed., Pearson Addison Wesley, SP, 2009.
    STEWART, J - Cálculo, vol.1, 6ª ed., SP, Cengage, 2010."
    matter.save

    code = "CM302"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.pd = 4
    matter.prerequisite = "CM301"
    matter.menu = "Funções de duas e três variáveis reais a valores reais. Mudanças de Coordenadas. Noções de derivadas parciais, plano tangente e vetor gradiente. Máximos e mínimos."
    matter.basic_bibliography = "HUGHES-HALLET, D. et al - Cálculo e Aplicações, Edgard Blucher, SP, 1999.
    HUGHES-HALLET, D. et al - Cálculo a uma e várias variáveis, Ed. LTC, RJ, 2011.
    SWOKOWSKI, E. - O cálculo com geometria analítica, vol. 1, 2ª ed., Makron Books, SP, 1995."
    matter.bibliography = "SIMMONS, G. F. - Cálculo com Geometria Analítica, vol. 2, McGraw-Hill, RJ, 1987.
    STEWART, J - Cálculo, vol.2, SP, Cengage, 2010."
    matter.save

    code = "CM303"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.pd = 4
    matter.menu = "Sistemas lineares e matrizes. Vetores no plano e no espaço. Produto escalar e produto vetorial. Autovalores e Autovetores de matrizes. Mudanças de coordenadas. Cônicas no plano."
    matter.basic_bibliography = "WINTERLE, P. - Vetores e Geometria Analítica, Makron Books, SP, 2000.
    ANTON, H., RORRES, C. - Álgebra Linear com Aplicações, Bookman, Porto Alegre, 2012.
    LEON, S. - Álgebra Linear: com Aplicações, 4a ed., LTC, RJ, 1999."
    matter.bibliography = "SANTOS, R. - Matrizes, Vetores e Geometria Analítica, BH, Imprensa da UFMG, 2010.
    LIPSCHUTZ, S. - Álgebra Linear, 3ª ed, Makron Books, SP, 1994.
    STEINBRUCH, A. e WINTERLE, P. - Álgebra Linear, 2ª ed., Unificado, Curitiba.
    STRANG, G. - Introdução à Álgebra Linear, GEN, SP, 2013.
    STEINBRUCH, A. e WINTERLE, P. - Introdução à Álgebra Linear, McGraw-Hill, SP, 1990."
    matter.save

    code = "CMA111"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.pd = 6
    matter.menu = "Função real de uma variável real. Limite e continuidade. Derivadas e reta tangente. Regras de derivação: linearidade, derivadas do produto e do quociente e Regra da Cadeia. Teorema do Valor Médio e a Fórmula de Taylor com Resto de Lagrange. Máximos e mínimos de funções. Primitivas. Integrais. Cálculo de área. Técnicas de integração. Função dada por uma integral e integrais impróprias. Aplicações. Tópicos de Cálculo."
    matter.basic_bibliography = "GUIDORIZZI, H. L. - Um Curso de Cálculo, vol. 1 e 2, LTC, RJ.
    STEWART, J. - Cálculo, vol. 1, Cengage Learning, SP.
    LEITHOLD, L. - O Cálculo com Geometria Analítica, vol. 1, Harbra, RJ."
    matter.bibliography = "SIMMONS, G. F. - Cálculo com Geometria Analítica, vol. 2, McGraw-Hill, RJ, 1987.
    APOSTOL. T. M. - Calculus, vol. 1, 2ª ed, John Wiley, New York, 1969.
    SPIVAK, M. - Calculus, Addison Wesley, London, 1973.
    ANTON, H. - Cálculo: um novo horizonte, vol. 1, Bookman, Porto Alegre, 2000.
    BOULOS, P. e ABUD, Z. I. - Cálculo Diferencial e Integral, vol. 1, Makron Books, SP, 1999.
    EDWARDS, C. H. e PENNEY, D. E. - Cálculo com geometria analítica, vol. 1, Prentice-Hall, SP, 1997.
    SWOKOWSKI, E. - O Cálculo com geometria analítica, vol. 1, Makron Books, SP.
    THOMAS, G. B. - Cálculo, vol. 1, 10ª ed., Pearson Addison Wesley, SP, 2002."
    matter.save

    code = "CMA112"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 60
    matter.pd = 4
    matter.menu = "Conceito geométrico de valor. Sistemas de coordenadas em R2 e R3. Produto escalar em R2 e R3. Produtos vetorial e misto no R3. Retas no plano e no espaço. Planos no espaço. Posições relativas entre retas e planos. Distâncias. Curgvas no plano (cônicas) e no espaço, parametrização de curvas. Superfícies no espaço (quádrivas), parametrização de superfícies. Aplicações."
    matter.basic_bibliography = "WINTERLE, P. - Vetores e Geometria Analítica, Makron Books, SP, 2000.
    STEINBRUCH, A. e WINTERLE, P. - Geometria Analítica, McGraw-Hill, SP, 1987.
    BOULOS, P. e CAMARGO, I. - Geometria Analítica: Um Tratamento Vetorial, 3ª ed., Pearson Prentice Hall, SP 2005."
    matter.bibliography = "PITOMBEIRA DE CARVALHO, J. - Vetores, Geometria Analítica e Álgebra Vetorial: Um Tratamento Moderno, Ao Livro Técnico, RJ, 1975.
    VENTURI, J. J. - Álgebra Vetorial e Geometria Analítica, 9ª ed., Unificado, Curitiba, 2001.
    VENTURI, J. J. - Cônicas e Quádricas, 5ª ed., Unificado, Curitiba, 2003.
    GUIDORIZZI, H. L. - Um curso de cálculo, vols. 1 e 2, LTC, RJ."
    matter.save

    code = "CMA211"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 90
    matter.pd = 6
    matter.prerequisite = "CMA111"
    matter.menu = "O Espaço Rn. Função de uma variável real a valores vetoriais: limite, continuidade, derivação e integração. FUnção de várias variáveis reais a valores reais. Limite, continuidade e derivadas parciais. Diferenciabilidade, plano tangente e o vetor gradiente. Regra da Cadeira, gradiente e derivadas de ordens superiores. Teorema do Valor Médio e Fórmula de Taylor com Resto de Lagrange (para função de várias variáveis). Máximos, mínimos e o Método dos Mulplicadores de Lagrange. Integral dupla e Teorema de Fubini. Mudança de variáveis na integral dupla. Cálculo de volumes, área de superfície e integral de superfície. Integral tripla. Mudança de variáveis na integral tripla. Aplicações. Função de várias variáveis reais a valores vetoriais. Integral de linha. Campo conservativo e forma diferencial exata. Cálculo vetorial e os Teoremas de Green, da Divergência (Gauss) e de Stokes. Tópicos de cálculo."
    matter.basic_bibliography = "GUIDORIZZI, H. L - Um curso de cálculo, vols 2 e 3, LTC, RJ.
    STEWART, J. - Cálculo, vol. 2, Cengage Learning, SP, 2010.
    LEITHOLD, J. - O cálculo com geometria analítica, vol. 2, Harbra, RJ."
    matter.bibliography = "SIMMONS, G. F. - Cálculo com Geometria Analítica, vol. 2, McGraw-Hill, RJ, 1987.
    APOSTOL, T. M - Calculus, vol. 2, 2ed, John Wiley, New York, 1969.
    SIMMONS, G. F. - Cálculo com Geometria Analítica, vol. 2, McGraw-Hill, RJ, 1987.
    ANTON, H. - Cálculo um novo horizonte, vol. 2, Bookman, Porto Alegre, 2000.
    THOMAS, G. B. - Cálculo, vol. 2, 10ed., Pearson Addison Wesley, SP, 2002.
    SWOKOWSKI, e. - O cálculo com geometria analítica, vol. 2, Makron Books, SP, 2000.
    BOULOS, P. e ABUD, Z. I. - Cálculo Diferencial e Integral, vol. 2, Makron Books, SP, 2000.
    EDWARDS, C. H. e PENNEY, D. E. - Cálculo com Geometria Analítica, vol. 2, Prentice-Hall, SP, 1997."
    matter.save

    code = "CMA311"
    matter = Matter.where(code: code)
    matter = matter.first
    matter.semester_workload = 9Í0
    matter.pd = 6
    matter.prerequisite = "CMA111"
    matter.menu = "Definição de equações diferenciais. Equações diferenciais ordinárias de 1a ordem. Equações diferenciais ordinárias de 2a ordem e de ordens superiores. Transformada de Laplace. Sistemas de equações diferenciais de 1a ordem: análises quantitativa e qualitativa. Soluções por séries de potências para equações diferenciais ordinárias. A Série de Fourier. Introdução as equações diferenciais parciais via séries de Fourier e método da separação de ariáveis: equações unidimensionais da onda e do calor. Tópicos de cálculo."
    matter.basic_bibliography = "KREYSZIG, E. - Matemática Superior, vols 1 e 2, 9a ed, LTC, RJ, 2009.
    BOYCE, W. E. e DI PRIMA, R. C. - Equações Diferenciais Elementares e Problemas de Valores de Contorno, 8a ed., LTC, RJ, 2010.
    SIMMONS, G. F. e KRANTZ, S. G. - Equações Diferenciais: Teoria, Técnica e Prática, McGraw-Hill, SP, 2008."
    matter.bibliography = "KREYSZIG, E. - Advanced Engineering Mathematics, 9th ed., John Wiley & Sons, 2006.
    ZILL, D. e CULLEN, M. R. - Equações Diferenciais, 3a ed., Pearson, SP, 2001.
    ZILL, D. - Equações Diferenciais com Aplicações em Modelagem, 1a ed., Cengage Learning, SP, 2009."
    matter.save



  end

end
