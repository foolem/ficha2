class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy, :open_wish]
  before_action :bar_define

  # GET /options
  # GET /options.json
  def index
    @options = Option.all
  end

  # GET /options/1
  # GET /options/1.json
  def show
  end

  # GET /options/new
  def new
    @option = Option.new
  end

  def search
    index
    render :index
  end

  def option_wish
    @wish = Wish.new(group_id: 1)
    respond_to do |format|
      format.js
    end
  end

  def generate
    Group.all.each do |group|
      if !has_option(group)
        option = Option.new
        option.semester = Semester.current_semester

        same_groups(group).each do |same_group|
          option.groups << same_group
        end

        option.save
      end
    end

    @options = Option.all

    respond_to do |format|
      format.html
      format.js
    end

  end

  # GET /options/1/edit
  def edit
  end

  # POST /options
  # POST /options.json
  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to @option, notice: 'Option was successfully created.' }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /options/1
  # PATCH/PUT /options/1.json
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to @option, notice: 'Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def option_params
      params.fetch(:option, {})
    end


    def bar_define
      session[:page] = "options"
    end

    def has_option(group)
      Option.all.each do |opt|
        if opt.groups.include? group
          return true
        end
      end
      return false
    end

    def same_groups(group)
      list = Group.where(matter: group.matter)
      result = []

      schedules = group.schedules

      list.each do |grp|
        if schedules == grp.schedules
          result << grp
        end
      end

      result
    end


end
