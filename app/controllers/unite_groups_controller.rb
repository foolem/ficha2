class UniteGroupsController < ApplicationController
  before_action :set_unite_group, only: [:show, :edit, :update, :destroy, :add, :remove]
  before_action :set_group, only: [:add, :remove]

  # GET /unite_groups
  # GET /unite_groups.json
  def index
    @unite_groups = UniteGroup.all
  end

  # GET /unite_groups/1
  # GET /unite_groups/1.json
  def show
  end

  # GET /unite_groups/new
  def new
    @unite_group = UniteGroup.new
  end

  # GET /unite_groups/1/edit
  def edit
    @opt_1 = Group.new


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

  # POST /unite_groups
  # POST /unite_groups.json
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

  # PATCH/PUT /unite_groups/1
  # PATCH/PUT /unite_groups/1.json
  def update
    respond_to do |format|
      if @unite_group.update(unite_group_params)
        format.html { redirect_to @unite_group, notice: 'União foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @unite_group }
      else
        format.html { render :edit }
        format.json { render json: @unite_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unite_groups/1
  # DELETE /unite_groups/1.json
  def destroy
    @unite_group.destroy
    respond_to do |format|
      format.html { redirect_to unite_groups_url, notice: 'União foi deletada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unite_group
      @unite_group = UniteGroup.find(params[:id])
    end

    def set_Group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unite_group_params
      params.require(:unite_group).permit(:name, :group)
    end
end
