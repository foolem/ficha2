class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :length_verify, only: [:index]
  before_action :bar_define

  def index
    @page = params[:page].to_i

    if(params[:q].blank? and !session[:group_search].blank?)
      query = session[:group_search]
    else
      query = params[:q]
      session[:group_search] = params[:q]
    end

    @q = Group.ransack(query)
    @groups = @q.result.order(name: :asc)
    @elements = @groups.length

    @page = pages_verify(@page, @elements, @length)
    @groups = @groups.paginate(:per_page => @length, :page => @page)

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

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :matter_id, :semester_id, :course_id)
    end

    def length_verify
      @length = 13
      if user_signed_in? and (current_user.admin? or current_user.secretary?)
        @length = 10
      end
    end

end
