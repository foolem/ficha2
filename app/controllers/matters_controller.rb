class MattersController < ApplicationController
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  def index

    @page = params[:page].to_i

    if(params[:q].blank? and !session[:matter_search].blank?)
      query = session[:matter_search]
    else
      query = params[:q]
      session[:matter_search] = params[:q]
    end

    length_verify()
    @q = Matter.ransack(query)
    @matters = @q.result.order(code: :asc)

    @elements = @matters.length
    @page = pages_verify(@page, @elements)

    @matters = @matters.paginate(:per_page => @length, :page => @page)
  end

  def search
    index
    render :index
  end

  def show
  end

  def new
    @matter = Matter.new
    @matter.prerequisite = "Nenhum"
    @matter.corequisite = "Nenhum"
    @matter.total_annual_workload = 0
    @matter.total_weekly_workload = 0
    @matter.total_modular_workload = 0
    @matter.weekly_workload = 0
    @matter.pd = 0
    @matter.lc = 0
    @matter.cp = 0
    @matter.es = 0
    @matter.or = 0

  end

  def edit
  end

  def create
    @matter = Matter.new(matter_params)

    if(@matter.prerequisite.blank?)
      @matter.prerequisite = 'Nenhum'
    end

    if(@matter.corequisite.blank?)
      @matter.corequisite = 'Nenhum'
    end
    @matter.code = @matter.code.upcase
    respond_to do |format|
      if @matter.save
        format.html { redirect_to @matter, notice: 'Disciplina foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @matter }
      else
        format.html { render :new }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @matter.update(matter_params)
        format.html { redirect_to @matter, notice: 'Disciplina foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @matter }
      else
        format.html { render :edit }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @matter.actived = !@matter.actived

    respond_to do |format|
      if(@matter.save)
        if(@matter.actived?)
          format.html { redirect_to matters_url, notice: 'Matéria ativada com sucesso.' }
        else
          format.html { redirect_to matters_url, notice: 'Matéria desativada com sucesso.' }
        end
        format.json { head :no_content }
      else
        format.html { redirect_to matters_url, alert: 'Erro ao atualizar matéria.' }
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
    result = num/@length
    resto = num.remainder @length
    if( resto > 0)
      result=result+1
    end
    result
  end

  def length_verify
    @length = 13
    if user_signed_in? and (current_user.admin? or current_user.secretary?)
      @length = 10
    end
  end

  private

    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.require(:matter).permit(:name, :code, :kind, :corequisite, :prerequisite, :modality, :menu, :nature,
      :total_annual_workload, :total_weekly_workload, :total_modular_workload, :weekly_workload,
      :pd, :lc, :cp, :es, :or)
    end

    def authorize_user
      authorize Matter
    end
end
