class UniteGroupsController < ApplicationController
  before_action :set_unite_group, only: [:show, :edit, :update, :destroy, :add, :remove]
  before_action :set_group, only: [:add, :remove]
  before_action :bar_define

  def index
    @unite_groups = UniteGroup.all
  end

  def show
  end

  def new
    @unite_group = UniteGroup.new
  end

  def edit
  end

  def add
    @unite_group.groups.push @group
    respond_to do |format|
      format.js
    end
  end

  def remove
    @unite_group.groups.delete(@group)
    respond_to do |format|
        format.js { flash[:alert] = "Turma removida com sucesso."}
    end
  end

  def create
    @unite_group = UniteGroup.new(unite_group_params)

    respond_to do |format|
      if @unite_group.save
        format.html { redirect_to edit_unite_group_path(@unite_group), notice: 'União foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @unite_group }
      else
        format.html { render :new }
        format.json { render json: @unite_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @unite_group.update(unite_group_params)
        format.html { redirect_to @unite_group, notice: 'União foi editada com sucesso.' }
        format.json { render :show, status: :ok, location: @unite_group }
      else
        format.html { render :edit }
        format.json { render json: @unite_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @unite_group.groups.delete_all
    @unite_group.destroy

    respond_to do |format|
      format.html { redirect_to unite_groups_url, notice: 'União foi deletada com sucesso.' }
      format.json { head :no_content }
    end
  end

  def choose
    @unite_matter = UniteMatter.find(params[:unite_matter_id])
    @unite_group = UniteGroup.find(params[:unite_group_id])
    puts @unite_matter.name

    respond_to do |format|
      format.js
    end
  end

  private
    def bar_define
      session[:page] = "groups"
    end

    def set_unite_group
      @unite_group = UniteGroup.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    def unite_group_params
      params.require(:unite_group).permit(:matter_id, :semester_id)
    end
end
