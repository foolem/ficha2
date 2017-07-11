class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy, :copy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create, :import]

  # GET /fichas
  # GET /fichas.json

  def index
    @page = params[:page].to_i

    puts "Parametros : #{params[:q]}"
    if(!(params[:q].blank? and !@query.blank?))
      @query = params[:q]
    end
    @q = Ficha.ransack(params[:q])

    @fichas = getFichas
    @elements = @fichas.length
    @page = pages_verify(@page, @elements)
    @fichas = @fichas.paginate(:per_page => 10, :page => @page)

  end

  def reload
    respond_to do |format|
      format.js
      format.html { redirect_to import_fichas_path, notice: 'que?' }
    end
  end

  def import
    $list = []
    $matters = []
    $teachers = []
  end

  def importing

    fichas = []
    $teachers = []
    $matters = []
    code = ''
    repeat = false

    file = params[:file]
    xlsx = open_spreadsheet(file)

    (xlsx.last_row - 2).times do |i|
      linha = xlsx.sheet(0).row(i+2)

      puts "|  #{linha[1]}  -  #{linha[2]}  -  #{linha[5]}  -  #{linha[26]} |"

      code = linha[5]
      matter_name = linha[1]
      teacher_name = linha[26]

      matter = Matter.where("code = '#{code}'")
      teacher = User.where("name = '#{teacher_name}'")

      if(!teacher.blank? and !matter.blank?)
        puts "Matéria e Professor ok"
        ficha = Ficha.new
        ficha.matter_id = 1
        ficha.user_id = 1
        ficha.team = linha[2]
        fichas << ficha
      else
        if(matter.blank?)
          if !contains_matter(code)
            matter = Matter.new(code: code, name: matter_name)
            $matters << matter
          end
        end

        if(teacher.blank?)
          if !contains_teacher(teacher_name)
            teacher = User.new(name: teacher_name)
            $teachers << teacher
          end
        end
      end

    end
    $list = fichas

  end

  def open_spreadsheet(file)
    case File.extname(file.original_filename)

    when ".xlsx" then Roo::Excelx.new(file.path, extension: :xlsx)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {col_sep: ","})
    when ".xls" then Roo::Excel.open(file.path, extension: :xlsx)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def search
    index
    render :index
    show_check
  end

  # GET /fichas/1
  # GET /fichas/1.json
  def show
    pdf_generate
  end


  # GET /fichas/new
  def new
    @ficha = Ficha.new
  end

  def copy

    ficha_new = Ficha.find(params[:copy_id])
    @ficha = Ficha.find(params[:id])
    if(ficha_new.matter == @ficha.matter and @ficha.user == current_user)

      @ficha.matter = ficha_new.matter
      @ficha.program = ficha_new.program
      @ficha.general_objective = ficha_new.general_objective
      @ficha.specific_objective = ficha_new.specific_objective
      @ficha.didactic_procedures = ficha_new.didactic_procedures
      @ficha.evaluation = ficha_new.evaluation
      @ficha.basic_bibliography = ficha_new.basic_bibliography
      @ficha.bibliography = ficha_new.bibliography

      if((user_signed_in? and current_user.admin?) and ficha_new.user.actived?)
        @ficha.user = ficha_new.user
      elsif(user_signed_in? and current_user.actived?)
        @ficha.user = current_user
      end
    else
      flash[:alert] = "Você não tem permissão para acessar esta página."
      redirect_to(request.referrer || fichas_path)
    end


  end

  # GET /fichas/1/edit
  def edit
    if(@ficha.user != current_user and !current_user.admin? and !current_user.appraiser? and !current_user.secretary?)
      flash[:alert] = "Você não tem permissão para acessar esta página."
      redirect_to(request.referrer || fichas_path)
    end
  end

  # POST /fichas
  # POST /fichas.json
  def create
    @ficha = Ficha.new(ficha_params)

    if(!current_user.admin?)
      @ficha.user = current_user
    end

    respond_to do |format|
      if @ficha.save
        format.html { redirect_to @ficha, notice: 'Ficha foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @ficha }
      else
        format.html { render :new }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fichas/1
  # PATCH/PUT /fichas/1.json
  def update
    list = ficha_params

    if(current_user.teacher?)
      if ficha_blank(Ficha.new(list))
        list[:status] = "Editando"
      else
        list[:status] = "Enviado"
      end
    end

    respond_to do |format|
      if @ficha.update(list )
        puts params[:status]
        format.html { redirect_to @ficha, notice: 'Ficha foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @ficha }
      else
        format.html { render :edit }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fichas/1
  # DELETE /fichas/1.json
  def destroy
    @ficha.destroy
    respond_to do |format|
      format.html { redirect_to fichas_url, notice: 'Ficha foi removida com sucesso.' }
      format.json { head :no_content }
    end
  end

  def getFichas
    if !user_signed_in?
      @q.result.order(year: :desc).where(status: 'Aprovado')
    elsif current_user.secretary?
      @q.result.order(year: :desc)
    else
      if(params[:checkbox])
        @q.result.order(status: :desc).where(user: current_user)
      else
        if current_user.appraiser? or current_user.admin? 
          @q.result.order(status: :desc)
        else
          @q.result.order(year: :desc).where(status: "Aprovado")
        end
      end
    end
  end

  def pages_verify(page, lines)
    pages = pages_count(lines)
    if(page < 1)

      page = 1
    elsif page > pages
      page = pages
    end

    page
  end

  def pages_count(num)
    pages = num/10
    resto = num.remainder 10
    if( resto > 0)
      pages=pages+1
    end
    pages
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ficha
      @ficha = Ficha.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ficha_params
      if current_user.appraiser? and @ficha.user.id != current_user.id
        params.require(:ficha).permit(:appraisal, :status)
      else
        params.require(:ficha).permit(:general_objective, :specific_objective, :program,
                                      :didactic_procedures, :evaluation, :basic_bibliography, :team,
                                      :bibliography, :user_id, :matter_id, :status, :semester, :year)
      end
    end

    def authorize_user
      authorize Ficha
    end

    def pdf_generate
      #https://www.youtube.com/watch?v=e-A3zBeWDdE

      respond_to do |format|
        format.html
        if(@ficha.status =="Aprovado")
          format.pdf do
            pdf = RecordPdf.new(@ficha)
            send_data pdf.render,
              filename: "Ficha2 #{@ficha.matter.code} - #{@ficha.user.name}",
              type: "application/pdf",
              disposition: "inline"
          end
        else
          format.pdf { redirect_to @ficha, alert: 'Este documento ainda não esta pronto.' }
        end
      end
    end

    def contains_matter(code)
      if !$matters.blank?
        $matters.each do |matter|
          if(matter.code == code)
            return true;
          end
        end
      end
      return false;
    end

    def contains_teacher(name)
      if !$teachers.blank?
        $teachers.each do |teacher|
          if(teacher.name == name)
            return true;
          end
        end
      end
      return false;
    end

    def ficha_blank(f)
      if(f.evaluation.blank? or f.program.blank? or f.bibliography.blank? or f.basic_bibliography.blank? or
         f.didactic_procedures.blank? or f.general_objective.blank? or f.specific_objective.blank?)
        true
      else
        false
      end
    end

end
