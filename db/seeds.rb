# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# rake db:drop db:create db:migrate db:seed

def create_users()

  User.create(name: "Admin", email: "adm@adm", password: "123123",  role: 2)
  User.create(name: "Professor", email: "prof@prof", password: "123123",  role: 0)
  User.create(name: "Avaliador", email: "av@av", password: "123123",  role: 1)
  User.create(name: "Secretário", email: "se@se", password: "123123",  role: 3)

end

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

def create_matters(quantity)

  quantity.times do |i|

    name = Faker::Food.ingredient
    code = Faker::Code.asin
    kind = [:Semestral, :Anual, :Modular].sample
    modality = [:Presencial, :EaD].sample
    nature = [:Obrigatoria, :Optativa].sample

    if name[0] >= 'a'
      name[0] = name[0].upcase
    end

    Matter.create(name: name, code: code, kind: kind,
    prerequisite: "Nenhum", corequisite: "Nenhum",
    modality: modality , nature: nature,
    total_weekly_workload: 0, total_modular_workload: 0, total_annual_workload: 0, weekly_workload: 0,
    pd:0, lc:0, cp:0, es:0, or:0)

    puts ("Criando matéria #{name}")

  end

end

def create_fichas_teacher()

  Ficha.create(matter_id: 1, user_id: 2, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Aprovado")

  Ficha.create(matter_id: 2, user_id: 2, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Reprovado", appraisal: "Melhore x e y")

  Ficha.create(matter_id: 3, user_id: 2, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z")
end

def create_teachers(quantity)

  matter = Matter.last
  quantity.times do |i|

    name = Faker::Name.name
    email = Faker::Internet.safe_email
    User.create(name: name, email:email, password: "123123")

    puts ("Criando professor #{name}, #{email}")

  end
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

def new_matter(name, code, kind, modality, nature, menu, total_w, total_m, total_a, weekly)
  new_matter_requisite(name, code, kind, modality, nature, menu, total_w, total_m, total_a, weekly, "Nenhum", "Nenhum")
end

def new_matter_requisite(name, code, kind, modality, nature, menu, total_w, total_m, total_a, weekly, requisite, corequisite)

  Matter.create(name: name, code: code, kind: kind,
  prerequisite: requisite, corequisite: corequisite,
  modality: modality , nature: nature, menu: menu,
  total_weekly_workload: total_w, total_modular_workload:  total_m, total_annual_workload: total_a, weekly_workload: weekly)

  puts ("Criando matéria #{name}")
end


def new_ficha(matter, user, objective, specific_objective, status, program, bibliography, basic_bibliography, evaluation, procedures)
  Ficha.create(matter_id: matter, user_id: user, general_objective: objective,
  specific_objective: specific_objective, status: status, program: program, basic_bibliography: basic_bibliography, bibliography: bibliography,
  evaluation: evaluation, didactic_procedures: procedures)

  puts ("Criando ficha: #{matter}")
end

def create_matters_example
  name = "Cálculo 1A"
  code = "CMA111"
  kind = :Semestral
  modality = :Presencial
  nature = :Obrigatoria
  menu = "Função real de uma variável real. Limite e continuidade. Derivadas e reta tangente. Regras de derivação: linearidade, derivadas do produto e do quociente e Regra da Cadeia. Teorema do Valor Médio e a Fórmula de Taylor com Resto de Lagrange. Máximos e mínimos de funções. Primitivas. Integrais. Cálculo de área. Técnicas de integração. Função dada por uma integral e integrais impróprias. Aplicações. Tópicos de Cálculo"

  new_matter(name, code, kind, modality, nature, menu, 90, 0, 0, 0)

  name = "Geometria Analítica"
  code = "CMA112"
  kind = :Semestral
  modality = :Presencial
  nature = :Obrigatoria
  menu = "Função real de uma variável real. Limite e continuidade. Derivadas e reta tangente. Regras de derivação: linearidade, derivadas do produto e do quociente e Regra da Cadeia. Teorema do Valor Médio e a Fórmula de Taylor com Resto de Lagrange. Máximos e mínimos de funções. Primitivas. Integrais. Cálculo de área. Técnicas de integração. Função dada por uma integral e integrais impróprias. Aplicações. Tópicos de CálculoConceito geométrico de vetor. Sistemas de coordenadas em R2 e R3. Produto escalar em R2 e R3. Produtos vetorial e misto no R3. Retas no plano e no espaço. Planos no espaço. Posições relativas entre retas e planos. Distâncias. Curvas no plano (cônicas) e no espaço, parametrização de curvas. Superfícies no espaço (quádricas), parametrização de superfícies. Aplicações."

  new_matter(name, code, kind, modality, nature, menu, 60, 0, 0, 0)

  name = "Cálculo 2A"
  code = "CMA211"
  kind = :Semestral
  modality = :Presencial
  nature = :Obrigatoria
  prerequisite = "CMA111"
  corequisite = "CMA112"

  menu = "O Espaço Rn. Função de uma variável real a valores vetoriais: limite, continuidade, derivação e integração. Função de várias variáveis reais a valores reais. Limite, continuidade e derivadas parciais. Diferenciabilidade, plano tangente e o vetor gradiente. Regra da Cadeia, gradiente e derivadas de ordens superiores. Teorema do Valor Médio e Fórmula de Taylor com Resto de Lagrange (para função de várias variáveis). Máximos, mínimos e o Método dos Multiplicadores de Lagrange. Integral dupla e Teorema de Fubini. Mudança de variáveis na integral dupla. Cálculo de volumes, área de superfície e integral de superfície. Integral tripla. Mudança de variáveis na integral tripla. Aplicações. Função de várias variáveis reais a valores vetoriais. Integral de linha. Campo conservativo e forma diferencial exata. Cálculo vetorial e os Teoremas de Green, da Divergência (Gauss) e de Stokes. Tópicos de cálculo."

  new_matter_requisite(name, code, kind, modality, nature, menu, 60, 0, 0, 0, prerequisite, corequisite)

  name = "Cálculo 3A"
  code = "CMA311"
  kind = :Semestral
  modality = :Presencial
  nature = :Obrigatoria
  prerequisite = "CMA111"
  corequisite = "CMA211 e CMA212"

  menu = "Definicao de equacoes diferenciais. Equacoes diferenciais ordinarias de 1a ordem. Equacoes diferenciais ordin ́arias de 2a ordem e de ordens superiores. Transformada de Laplace. Sistemas de equacoes diferenciais de 1a ordem: análises quantitativa e qualitativa. Soluções por series de potências para equações diferenciais ordinárias. A Serie de Fourier. Introducao às equacoes diferenciais parciais via series de Fourier e método da separação de variáveis: equações unidimensionais da onda e do calor. Topicos de calculo."

  new_matter_requisite(name, code, kind, modality, nature, menu, 60, 0, 0, 0, prerequisite, corequisite)

end

def create_fichas_example

  objective = "Apresentar os conceitos de limite, derivada e integral para funções de uma variável, bem como suas aplicações: problemas de retas tangente e normal a um gráfico, aproximação de uma função, máximos e mínimos de funções, cálculo de áreas."

  specific_objective = "Ao fim desta disciplina o estudante deverá saber técnicas para calcular limites de funções de uma variável, técnicas para calcular derivadas de funções de uma variável, e técnicas de integração de funções de uma variável: substituição, integral por partes, mudança de variáveis, integração de funções trigonométricas, integração por frações parciais e integrais impróprias, bem como compreender todos os conceitos envolvidos."

  program ="Função real de uma variável real. Definição de função de uma variável real a valores reais. Gráfico. Limite e continuidade. Definição de limite e continuidade. Teorema do Confronto. Funções trigonométricas. O limite fundamental. Propriedades dos limites. Sequências numéricas e o número e. As funções exponencial e logarítmica. Regras de derivação: linearidade, derivadas do produto e do quociente e Regra da Cadeia. Linearidade da derivada. Regras do produto e do quociente. Função derivada e derivadas de ordem superior. Derivada de função composta: Regra da Cadeia. Derivação implícita. Retas tangente e normal a uma curva. Funções inversas e suas derivadas. Teorema do Valor Médio e a Fórmula de Taylor com Resto de Lagrange. Teorema do valor médio. Fórmula de Taylor de uma função: aproximação de uma função por um  polinômio. Resto de Lagrange: erro cometido na aproximação de uma função por um polinômio."

  bibliography ="GUIDORIZZI, H. L. - Um Curso de Cálculo, vol. 1 e 2, LTC, Rio de Janeiro.
  STEWART, J. - Cálculo, vol. 1, Cengage Learning, São Paulo.
  LEITHOLD, L. - O Cálculo com Geometria Analítica, vol. 1, Harbra, Rio de Janeiro."

  basic_bibliography = "APOSTOL, T. M. - Calculus, vol. 1, 2 ed., John Wiley, New York, 1969.
  SPIVAK, M. - Calculus, Addison Wesley, London, 1973.
  ANTON, H. - Cálculo: um novo horizonte, vol. 1, Bookman, Porto Alegre, 2000.
  BOULOS, P. e ABUD, Z. I. - Cálculo Diferencial e Integral, vol. 1, Makron Books, São Paulo,1999.
  EDWARDS, C. H. e PENNEY, D.E. - Cálculo com geometria analítica, vol. 1, Prentice-Hall, São Paulo, 1997.
  SIMMONS, G. F. - Cálculo com Geometria Analítica, vol. 1, McGraw-Hill, Rio de Janeiro, 1987.
  SWOKOWSKI, E. - O Cálculo com Geometria Analítica, vol. 1 , Makron Books, São Paulo.
  THOMAS, G. B. - Cálculo, vol. 1, 10 ed., Pearson Addison Wesley, São Paulo, 2002."

  evaluation = "No decorrer do semestre serão feitas provas e/ou trabalhos, testes, apresentação de seminários, etc. Segunda chamada e exame final serão feitos conforme disposto nas resoluções CEPE-37/97 e CEPE-54/09."

  procedures = "Serão ministradas aulas expositivas, com ou sem uso de multimídia, apresentação de seminários e outros."

  new_ficha(1, 2, objective, specific_objective, "Aprovado", program, bibliography, basic_bibliography, evaluation, procedures)


  objective = "Apresentar os espaços R2 / R3 e a representação de curvas, cônicas, planos e superfícies nos mesmos, estudar distâncias, posições relativas e ortogonalidade entre retas/planos."
  specific_objective = "Desenvolver no estudante a capacidade de 'enxergar' no espaço, visualizar curvas no plano e no espaço e superfícies no espaço (importante para desenhar gráficos de funções). Ao fim desta disciplina o estudante deverá saber representar/parametrizar curvas/superfícies nos espaços R2 e R3, saber reconhecer as cônicas/quádricas nas suas formas reduzidas, bem como compreender os conceitos envolvidos."
  program ="Conceito geométrico de vetor. Segmento orientado para definir vetor e as operações adição e multiplicação por escalar. Sistemas de coordenadas em R2 e R3. Definição. Vetores no R2 e R3 e operações de adição e multiplicação por escalar R2 e R3. Produto escalar em R2 e R3. Definição. Ortogonalidade e ângulo entre vetores. Produtos vetorial e misto no R3. Definição, significado geométrico e aplicações (cálculo de volumes). Retas no plano e no espaço. Equação geral (R2), equação vetorial, representação paramétrica, representação simétrica. Planos no espaço. Equação geral, equação vetorial, representação paramétrica. Reta dada como interseção de dois planos. Posições relativas entre retas e planos. Reta e reta: paralelas, perpendiculares (ortogonais) e reversas (ortogonais ou não). Ângulo entre retas. Reta e plano: reta paralela (contida ou não), perpendicular ou inclinada ao plano. Ângulo entre reta e plano. Plano e plano: paralelos, perpendiculares ou inclinados. Ângulo entre planos. Distâncias. Entre pontos, de ponto a reta e de ponto a plano. Entre retas paralelas ou reversas. De reta a plano, entre planos paralelos."

  bibliography ="WINTERLE, P. - Vetores e Geometria Analítica, Makron Books, São Paulo, 2000.
STEINBRUCH, A. e WINTERLE, P. - Geometria Analítica, McGraw-Hill, São Paulo, 1987.
BOULOS, P. e CAMARGO, I. - Geometria Analítica: Um Tratamento Vetorial, 3ed., Pearson
Prentice Hall, São Paulo, 2005."

  basic_bibliography = "PITOMBEIRA DE CARVALHO, J. - Vetores, Geometria Analítica e Álgebra Vetorial: Um Tratamento Moderno, Ao Livro Técnico, Rio de Janeiro, 1975.
VENTURI, J. J. - Álgebra Vetorial e Geometria Analítica, 9ed., Unificado, Curitiba. 2001.
VENTURI, J. J. - Cônicas e Quádricas, 5ed., Unificado, Curitiba. 2003.
GUIDORIZZI, H. L. - Um Curso de Cálculo, vols. 1 e 2, LTC, Rio de Janeiro."

  evaluation = "No decorrer do semestre serão feitas provas e/ou trabalhos, testes, apresentação de seminários, etc. Segunda chamada e exame final serão feitos conforme disposto nas resoluções CEPE-37/97 e CEPE-54/09."

  procedures = "Serão ministradas aulas expositivas, com ou sem uso de multimídia, apresentação de seminários e outros."

  new_ficha(2, 2, objective, specific_objective, "Reprovado", program, bibliography, basic_bibliography, evaluation, procedures)


  objective = "Apresentar diversas técnicas para resolver equações diferenciais ordin ́arias e parcias."
  specific_objective = "Ao fim desta disciplina o estudante deveré saber técnicas para resolver equações diferencias ordinárias de 1a ordem (separação de variáveis, equações exatas e fator integrante), de 2a ordem com coeficientes constantes, homogêneas e não homogêneas (coeficientes indeterminados e variação de parâmetros), saber usar a Transformada de Laplace, resolver sistemas de equações diferencias lineares via autovalores e autovetores, fazer análise de estabilidade de pontos críticos de sistemas de equações, usar a Série de Fourier para representar funções periódicas e saber resolver problemas envolvendo as equações diferenciais parciais da onda e do calor unidimensionais."
  program ="Definição de equações diferenciais. Definição. Classificação. Famı́lias de curvas. Trajetórias Ortogonais. Modelos Matemáticos. Teorema de Existência e Unicidade de Soluções.

  Equações diferenciais ordinárias de 1 a ordem. Equações diferencias separáveis. Equações diferencias Exatas. Fatores Integrantes. Equações diferencias lineares de 1 a ordem.Redução a equação linear: Equação de Bernoulli.

  Equações diferenciais ordinárias de 2 a ordem e de ordens superiores. Redução de ordem. Equações diferencias lineares de 2 a ordem com coeficientes constantes, homogêneas: equação caracterı́stica; e não homogêneas: Método dos Coeficientes Indeterminados e Método da Variação de Parâmetros(dependência e independência linear das soluções, uso do Wronskiano). Solução de equações de ordens superiores.

  Transformada de Laplace. Definição. Transformada Inversa. Linearidade. 1 o Teorema do Deslocamento. Transformada de Laplace da derivada e da integral. Resolvendo equações diferenciais. Teoremas de Deslocamento. A Função Degrau Unitário. 2 o Teorema do Deslocamento. A Função Delta de Dirac. Diferenciação e Integração de Transformadas. Convolução. Equações Integrais.

  Sistemas de equações diferenciais de 1 a ordem: análises quantitativa e qualitativa. Resolvendo sistemas homogêneos de equações diferenciais com autovalores e autovetores. Plano de Fase. Estabilidade de pontos crı́ticos. Resolvendo sistemas de equações diferenciais com Transformada de Laplace. Solução para sistemas não homogêneos: por coeficientes indeterminados e variação de parâmetros.

  Soluções por séries de potências para equações diferenciais ordinárias. Sequências e séries numéricas. As Séries de Taylor e de McLaurin: representação de funções por séries de potências. O Método das Séries de Potências. A Equação de Legendre e os Polinômios de Legendre. O Método de Frobenius. A Equação de Bessel. A função de Bessel de 1 o tipo J ν (x). A função de Bessel de 2 o tipo Y ν (x).

  A Série de Fourier. O problema Sturm-Liouville. Autovalores, autofunções e funções ortogonais. Expansão em série de funções ortogonais. A Série de Fourier e a representação de funções periódicas.

  Introdução às equações diferenciais parciais via séries de Fourier e método da separação de variáveis: equações unidimensionais da onda e do calor. Método da Separação de Variáveis. As equações da onda e do calor unidimensionais: soluções por séries de Fourier. Tópicos de cálculo. Representação de funções não periódicas: a Integral de Fourier. Uso da Integral de Fourier para calcular integrais definidas. Equação Unidimensional do Calor para uma barra semi-infinita: uso da integral de Fourier."

  bibliography ="KREYSZIG, E. - Advanced Engineering Mathematics, 9 th ed., John Wiley & Sons, 2006.
  ZILL,D. e CULLEN, M. R. - Equações Diferenciais, 3 a ed., Pearson, São Paulo, 2001.
  ZILL,D. - Equações Diferenciais com Aplicações em Modelagem, 1 a ed., Cengage Learning, São Paulo, 2009."

  basic_bibliography = "KREYSZIG, E. - Matemática Superior, vols. 1 e 2, 9 a ed., LTC, Rio de Janeiro, 2009.
  BOYCE, W. E. e DI PRIMA, R. C. - Equações Diferenciais Elementares e Problemas de Valores de Contorno, 8 a ed.,
  LTC, Rio de Janeiro, 2010.
  SIMMONS, G. F. e KRANTZ, S. G. - Equações Diferenciais: Teoria, Técnica e Prática, Mc Graw-Hill, São Paulo,
  2008."

  evaluation = "No decorrer do semestre serão feitas provas e/ou trabalhos, testes, apresentação de seminários, etc. Segunda chamada
  e exame final serão feitos conforme disposto nas resoluções CEPE-37/97 e CEPE-54/09."

  procedures = "Serão ministradas aulas expositivas, com ou sem uso de multimı́dia, apresentação de seminários e outros."

  new_ficha(4, 2, objective, specific_objective, "Enviado", program, bibliography, basic_bibliography, evaluation, procedures)

end


create_matters_example()
create_matters(20)
create_users()
create_fichas_example()
create_fichas_teacher()
create_teachers(20)
create_fichas(20, "Enviado", "")
create_fichas(20, "Reprovado", "Bibliografia fora das normas")
create_fichas(20, "Aprovado", "")
