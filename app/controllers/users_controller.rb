class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :user_edit, :create, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]
  before_action :bar_define

  def index
    @q = User.search(model_define("User"))
    @users = @q.result.order(name: :asc)
    @elements = @users.length

    @page = params[:page].to_i
    @page = pages_verify(@page, @elements, page_length)
    @users = @users.paginate(:per_page => page_length, :page => @page)
  end

  def search
    index
    render :index
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
        #@user.send_reset_password_instructions
        #UserMailer.send_password(@user).deliver

        format.html { redirect_to users_path, notice: 'Usuário criado com sucesso.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    update_roles
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

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :password, :email, :password_confirmation, :phone, :role_ids)
    end

    def authorize_user
      authorize User
    end

    def bar_define
      session[:page] = "user"
    end

    def page_length
      if(!user_signed_in? or !current_user.admin?)
        return 13
      end
      10
    end

    def remove_all_roles
      Role.permited_roles.each do |role|
        @user.remove_role(role)
      end
    end


     def update_roles
      remove_all_roles
      roles = params[:user][:role_ids]
      if !roles.blank?
        roles.each do |role|
          if role != ""
            puts role.to_i - 1
            puts Role.role_by_index (role.to_i - 1)
            @user.add_role(Role.role_by_index (role.to_i - 1))
          end
        end
      end
    end

end
