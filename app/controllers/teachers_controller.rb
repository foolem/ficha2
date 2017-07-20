class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  def index

    if(params[:q].blank? and !session[:teacher_search].blank?)
      query = session[:teacher_search]
    else
      query = params[:q]
      session[:teacher_search] = params[:q]
    end

    @q = User.search(query)

    length_verify()
    @page = params[:page].to_i
    @teachers = @q.result.where("role = 0").order(name: :asc)
    @elements = @teachers.length
    @page = pages_verify(@page, @elements)
    @teachers = @teachers.paginate(:per_page => @length, :page => @page)
  end

  def search
    index
    render :index
  end

  def show
  end

  def new
    @teacher = User.new
  end

  def edit
  end

  def create
    @teacher = User.new(teacher_params)

    respond_to do |format|

      if @teacher.name.blank?
        format.html { redirect_to new_teacher_path, notice: 'O nome é necessário.' }

      else
        if @teacher.save

          format.html { redirect_to @teacher, notice: 'Professor foi criado com sucesso.' }
          format.json { render :show, status: :created, location: @teacher }
        else
          format.html { render :new }
          format.json { render json: @teacher.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Professor foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teacher.actived = !@teacher.actived
    @teacher.save

    respond_to do |format|
      if(@teacher.actived?)
        format.html { redirect_to teachers_url, notice: 'Professor ativado com sucesso.' }
      else
        format.html { redirect_to teachers_url, notice: 'Professor desativado com sucesso.' }
      end

      format.json { head :no_content }
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
    @length = 10
    if(!user_signed_in? or !current_user.admin?)
      @length = 13
    end
  end

  private
    def set_teacher
      @teacher = User.find(params[:id])
    end

    def teacher_params
      params.require(:teacher).permit(:name)
    end

    def authorize_user
      authorize User
    end
end
