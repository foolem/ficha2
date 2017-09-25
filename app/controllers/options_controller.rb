class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy, :open_wish]
  before_action :set_wish, only: [:open_comment]
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :bar_define

  def index
    @unites = []

    @q = Option.ransack(model_define("Option"))
    @options = @q.result
    @elements = @options.length

    @page = params[:page].to_i
    @page = pages_verify(@page, @elements, page_length)
    @options = @options.paginate(:per_page => page_length, :page => @page)

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
    @unites = []
    #cleaner
    Group.where(semester_id: Semester.current_semester.id).each do |group|
      option_generate(group)
    end

    respond_to do |format|
      format.js
      format.html { redirect_to options_path, notice: 'Opções geradas com sucesso.' }
    end
  end

  def option_generate(group)
    if !has_option_group(group.id)
      option = Option.new
      option.semester = Semester.current_semester

      same_groups(group).each do |same_group|
        option.groups << same_group
      end

      option.save
    end
  end

  def cleaner
    Wish.delete_all
    Group.all.each do |grp|
      grp.option = nil
      grp.save
    end
    Option.destroy_all
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

  def open_comment
    puts @wish.comments

    respond_to do |format|
      format.js

    end
  end

  private

    def bar_define
      session[:page] = "options"
    end

    def set_option
      @option = Option.find(params[:id])
    end

    def set_wish
      @wish = Wish.find(params[:id_wish])
    end

    def option_params
      params.fetch(:option, {})
    end

    def page_length
      30
    end

    def authorize_user
      authorize Option
    end

    def same_groups(group)

      result = []
      if group.schedules.length == 0
        result << group
        return result
      end

      groups = []

      if !group.matter.unite_matter.blank?
        group.matter.unite_matter.matters.each do |matter|
          matter.groups.each do |grp|
            groups << grp
          end
        end
      else
        groups = group.matter.groups
      end

      schedules = group.schedules

      groups.each do |grp|
        if schedules == grp.schedules
          result << grp
        end
      end

      result
    end

    def select_options_unite(unite_id)
      "select distinct o.id from options as o
      inner join groups as g on g.option_id = o.id
      inner join matters as m on g.matter_id = m.id
      where m.unite_matter_id = #{unite_id};"
    end

    def select_options_matters(matter_id)
      "select distinct g.id from groups as g
      inner join matters as m on g.matter_id = m.id
      where m.unite_matter_id = #{matter_id};"
    end

    def select_options_group(group_id)
      "select o.id from options as o
      inner join groups as g on o.id = g.option_id
      where g.id = #{group_id};"
    end

    def select_result(query)
      list = []
      conn = ActiveRecord::Base.connection
      result = conn.execute query

      result.each do |r|
        list << r[0]
      end
      list
    end

    def has_option_group(group_id)
      result = false
      options = select_result(select_options_group(group_id))
      options.each { |option| result = true }
      result
    end

end
