class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :bar_define
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  def index
    @q = Group.ransack(model_define("Group"))

    @groups = @q.result.joins(:matter).order('matters.code, name')

  end

  def show
    @show = true
  end

  def search
    index
    render :index
  end

  def new
    @group = Group.new
  end

  def edit
    @schedule = Schedule.new
  end

  def schedule
    @schedule = Schedule.new(begin: Time.new(2012,6,30,23,59,60,0).to_time)
  end

  def create
    @group = Group.new(group_params)
    @group.name = name_sugestion

    respond_to do |format|
      if @group.save
        format.html { redirect_to edit_group_path(@group), notice: 'Turma foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Turma foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Turma foi excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  def name_sugestion
    if @group.name.blank?
      names = ("A".. "Z").to_a
      index = Group.where(semester: @group.semester, matter: @group.matter).length
      names[index]
    else
      @group.name
    end
  end


  private
    def bar_define
      session[:page] = "group"
    end

    def authorize_user
      authorize Group
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :matter_id, :semester_id, :course_id)
    end

    def page_length
      if user_signed_in? and (current_user.admin? or current_user.secretary?)
        return 10
      end
      13
    end

end
