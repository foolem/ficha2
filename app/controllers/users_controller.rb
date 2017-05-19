class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  def index

    if(@kind.blank?)
      @kind = "role = 1 or role = 2"
      puts @kind
    end
    puts @kind

    @q = User.search(params[:q])
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

  def teachers
    @kind = "role = 0"
    puts @kind
    index
    render :index

  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Usuário criado com sucesso.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.actived = !@user.actived
    @user.save

    respond_to do |format|

      if(@user.actived?)
        format.html { redirect_to users_url, notice: 'Usuário ativado com sucesso.' }
      else
        format.html { redirect_to users_url, notice: 'Usuário desativado com sucesso.' }
      end

      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pages_verify(page, lines)
    pages = pages_count(lines)
    puts "Page teste  : #{page}"
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
