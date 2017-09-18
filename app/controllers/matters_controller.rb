class MattersController < ApplicationController
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]
  before_action :bar_define

  def index
    @q = Matter.ransack(model_define("Matter"))
    @matters = @q.result.order(code: :asc)
    @elements = @matters.length

    @page = params[:page].to_i
    @page = pages_verify(@page, @elements, page_length)
    @matters = @matters.paginate(:per_page => page_length, :page => @page)
  end

  def search
    index
    render :index
  end

  def show
  end

  def new
    @matter = Matter.new
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

  private

    def bar_define
      session[:page] = "matter"
    end

    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.require(:matter).permit(:name, :code, :kind, :corequisite, :prerequisite, :modality, :menu, :nature,
      :total_annual_workload, :total_weekly_workload, :total_modular_workload, :weekly_workload,
      :pd, :lc, :cp, :es, :or, :basic_bibliography, :bibliography)
    end

    def authorize_user
      authorize Matter
    end

    def page_length
      if user_signed_in? and (current_user.admin? or current_user.secretary?)
        return 10
      end
      13
    end

end
