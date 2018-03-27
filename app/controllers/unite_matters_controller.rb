class UniteMattersController < ApplicationController
  before_action :set_unite_matter, only: [:show, :edit, :update, :destroy, :add, :remove]
  before_action :set_matter, only: [:add, :remove]
  before_action :authorize_user, only: [:index, :show, :new, :add, :remove, :create, :destroy]
  before_action :authenticate_user!, only: [:index, :edit, :update, :add, :remove, :destroy, :create]
  before_action :bar_define

  def index
    @unite_matters = UniteMatter.all
  end

  def show
  end

  def new
    @unite_matter = UniteMatter.new
  end

  def edit
  end

  def add
    @unite_matter.matters.push @matter
    respond_to do |format|
      format.js
    end
  end

  def remove
    @unite_matter.matters.delete(@matter)
    respond_to do |format|
        format.js { flash[:alert] = "Disciplina removido com sucesso."}
    end
  end

  def create
    @unite_matter = UniteMatter.new(unite_matter_params)

    respond_to do |format|
      if @unite_matter.save
        format.html { redirect_to edit_unite_matter_path(@unite_matter), notice: 'União foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @unite_matter }
      else
        format.html { render :new }
        format.json { render json: @unite_matter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @unite_matter.update(unite_matter_params)
        format.html { redirect_to @unite_matter, notice: 'União foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @unite_matter }
      else
        format.html { render :edit }
        format.json { render json: @unite_matter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @unite_matter.matters.delete_all
    @unite_matter.destroy
    respond_to do |format|
      format.html { redirect_to unite_matters_url, notice: 'União foi deletada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

    def authorize_user
      authorize UniteMatter
    end

    def bar_define
      session[:page] = "matters"
    end

    def set_unite_matter
      @unite_matter = UniteMatter.find(params[:id])
    end

    def set_matter
      @matter = Matter.find(params[:matter_id])
    end

    def unite_matter_params
      params.require(:unite_matter).permit(:name, :matter)
    end

end
