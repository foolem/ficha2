class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy, :open_wish]
  before_action :bar_define

  def index
    @options = Option.all
  end

  def show
  end

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
    Wish.delete_all
    Group.all.each do |grp|
      grp.option = nil
      grp.save
    end
    Option.destroy_all

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

  def edit
  end

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

  def destroy
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def bar_define
      session[:page] = "options"
    end

    def set_option
      @option = Option.find(params[:id])
    end

    def option_params
      params.fetch(:option, {})
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

      groups = []
      list.each { |grp| groups << grp }

      if !group.matter.unite_matter.blank?
        x = []
        other_list = group.matter.unite_matter.matters.select {|matter| matter != group.matter}
        other_list.each do |matter|
          Group.where(matter: matter).each do |grp|
            groups << grp
          end
        end
      end

      result = []

      schedules = group.schedules

      groups.each do |grp|
        if schedules == grp.schedules
          result << grp
        end
      end

      result
    end

end
