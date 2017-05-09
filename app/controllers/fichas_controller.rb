class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  # GET /fichas
  # GET /fichas.json
  def index

    @page = params[:page].to_i
    @fichas = getFichas
    @elements = @fichas.length
    @page = pages_verify(@page, @elements)
    @fichas = @fichas.paginate(:per_page => 10, :page => @page)


  end

  def search
    index
    render :index
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
    respond_to do |format|
      if @ficha.update(ficha_params)
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
    if !user_signed_in?
      Ficha.order(created_at: :desc).where(status: "Aprovado")
    elsif current_user.teacher?
      Ficha.order(status: :desc).where(user: current_user)
    else
      if(@kind == "Enviado")
        puts "Kind: #{@kind}"
        Ficha.order(status: :desc).where(status: "Enviado")
      else
        puts "Kind: #{@kind}"
        Ficha.order(status: :desc)
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
      params.require(:ficha).permit(:general_objective, :specific_objective,
                                    :didactic_procedures, :evaluation, :basic_bibliography,
                                    :bibliography, :user_id, :matter_id, :appraisal, :status)
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
