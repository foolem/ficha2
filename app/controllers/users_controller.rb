class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :user_edit, :create, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  def index

    if(@kind.blank?)
      @kind = "role != 0"
    end

    if(params[:q].blank? and !session[:user_search].blank?)
      query = session[:user_search]
    else
      query = params[:q]
      session[:user_search] = params[:q]
    end

    @q = User.search(query)

    length_verify()
    @page = params[:page].to_i
    @users = @q.result.where(@kind).order(name: :asc)
    @elements = @users.length
    @page = pages_verify(@page, @elements)
    @users = @users.paginate(:per_page => @length, :page => @page)

  end

  def search
    index
    render :index
  end

  def teacher_search
    @kind = "role = 0"
    teachers
    render :teachers
  end

  def teachers
    @kind = "role = 0"
    index
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    if(@user != current_user)
      user_edit
    end
  end

  def user_edit
    if(!current_user.admin?)
      flash[:alert] = "Você não tem permissão para acessar esta página."
      redirect_to(request.referrer || root_path)
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to welcome_index_path, notice: 'Usuário criado com sucesso.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    list = user_params

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to welcome_index_path, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.actived = !@user.actived

    if(!@user.teacher?)
      path = users_path
    else
      path = teachers_users_url
    end

    respond_to do |format|
      if(@user.save)
        if(@user.actived?)
          format.html { redirect_to path, notice: 'Usuário ativado com sucesso.' }
        else
          format.html { redirect_to path, notice: 'Usuário desativado com sucesso.' }
        end
        format.json { head :no_content }
      else
        format.html { redirect_to path, alert: 'Erro ao atualizar usuário.' }
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
    @length = 10
    if(!user_signed_in? or !current_user.admin?)
      @length = 13
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :password, :email, :password_confirmation, :role)
    end

    def authorize_user
      authorize User
    end
end
