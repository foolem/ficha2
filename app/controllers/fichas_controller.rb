class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy, :copy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create, :import]

  # GET /fichas
  # GET /fichas.json

  def index
    @page = params[:page].to_i

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
  end

  def importing

    $list = []
    fichas = []

    file = params[:file]
    xlsx = open_spreadsheet(file)
    fichas = []

    puts
    (xlsx.last_row).times do |i|
      linha = xlsx.sheet(0).row(i+1)
      puts "|  #{linha[1]}  -  #{linha[2]}  -  #{linha[5]}  -  #{linha[26]} |"

      matter = Matter.where("code = '#{linha[5]}'")
      if(!matter.blank?)
        puts "Matéria existe"
        ficha = Ficha.new
        ficha.matter_id = 1
        ficha.user_id = 1
        fichas << ficha

      else
        puts "Não existe"
      end

    end
    puts

    $list = fichas
    puts "OPAAA: #{$list.length}"

    respond_to do |format|
        format.html { flash[:notice] = "Html request..."}
        format.js { flash[:notice] = "JS request..."}
    end

  end

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
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

  # https://www.youtube.com/watch?v=e-A3zBeWDdE

  # GET /fichas/new
  def new
    @ficha = Ficha.new
  end

  def copy
    ficha_new = Ficha.find(params[:id])
    @ficha = Ficha.new
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

  end

  # GET /fichas/1/edit
  def edit

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
        format.html { redirect_to @ficha, notice: 'Ficha was successfully created.' }
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
      list[:status] = "Enviado"
    end

    respond_to do |format|
      if @ficha.update(list )
        puts params[:status]
        format.html { redirect_to @ficha, notice: 'Ficha was successfully updated.' }
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
      format.html { redirect_to fichas_url, notice: 'Ficha was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def getFichas
    if !user_signed_in? or !current_user.teacher?
      @q.result.order(year: :desc)
    else
      if(params[:checkbox])
        puts "TA ATIVADO MEMO PARÇA"
        @q.result.order(year: :desc).where(user: current_user)
      else
        puts "TA DESLIGADAO MEMO"
        @q.result.order(year: :desc)
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
      params.require(:ficha).permit(:general_objective, :specific_objective, :program,
                                    :didactic_procedures, :evaluation, :basic_bibliography, :team,
                                    :bibliography, :user_id, :matter_id, :appraisal, :status, :semester, :year)
    end

    def authorize_user
      authorize Ficha
    end

    def pdf_generate
      respond_to do |format|
        format.html
        format.pdf do
          pdf = RecordPdf.new(@ficha)

          send_data pdf.render,
            filename: "Ficha2 #{@ficha.matter.name} #{@ficha.user.name}",
            type: "application/pdf",
            disposition: "inline"
        end
      end
    end
end
