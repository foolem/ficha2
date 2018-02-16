class ManageOptionsController < ApplicationController
  before_action :authorize_user
  #before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]
  before_action :set_semester
  before_action :bar_define





  def pass_generate
    password = ""
    character = ("0".."9").to_a + ("a".."f").to_a
    6.times do |i|
      password << character.sample
    end
    password
  end

  def send_to(user)
      password = pass_generate
      user.password = password
      user.password_confirmation = password
      user.save
      puts "User: #{user.name}\tPassword: #{password}"
      Thread.new { UserMailer.send_password(user).deliver }
  end

  def send_email
    @action = :send_email
    users = User.all
    users.each do |user|
      # >=5 para ignorar usuários padrão do sistema
      #if user.id >= 5 && user.id <= 59
      if user.id == 7
        send_to(user)
      end
    end
    respond_to do |format|
      format.js { render :action => 'manage_result'}
    end
  end

  def generate
    @action = :generate
    #condition = !@semester.options_generated?
    options_status(true, true, false, false)

    generate_method

    respond_to do |format|
      format.js { render :action => 'manage_result'}
    end
  end

  def remove
    @action = :remove
    #condition = @semester.options_generated? and !@semester.options_selection?
    options_status(true, false, false, false)

    Option.hard_reset

    respond_to do |format|
      format.js { render :action => 'manage_result'}
    end
  end

  def start
    @action = :start
    #condition = @semester.options_generated? and !@semester.options_selection?
    options_status(true, true, true, false)

    respond_to do |format|
      format.js { render :action => 'manage_result'}
    end
  end

  def end
    @action = :end
    #condition = @semester.options_generated? and @semester.options_selection?
    options_status(true, true, false, true)

    # somente para testes
    # options_status(true, false, false, false)

    respond_to do |format|
      format.js { render :action => 'manage_result'}
    end
  end

  def teacher_report(*args)
    respond_to do |format|
      format.pdf do
          pdf = TeacherReportPdf.new(args.first)
          send_data pdf.render,
            filename: "Relatório por docente.pdf",
            type: "application/pdf",
            disposition: "inline"
        end
    end
  end

  def final_report(*args)
    respond_to do |format|
      format.pdf do
          pdf = FinalReportPdf.new(args.first)
          send_data pdf.render,
            filename: "Relatório relação docente disciplina.pdf",
            type: "application/pdf",
            disposition: "inline"
        end
    end
  end

  def matter_report(*args)
    respond_to do |format|
      format.pdf do
          pdf = MatterReportPdf.new(args.first)
          send_data pdf.render,
            filename: "Relatório por disciplina.pdf",
            type: "application/pdf",
            disposition: "inline"
        end
    end
  end

  def index
    delivery
  end

  def delivery
    if @semester_id.blank?
      @semester_id = Semester.current_semester.id
    end
  end

  def search
    @semester_id = params[:semester_id]
    render :delivery
  end

  def find_pdf
    semester = params[:semester_id]
    btn = params[:selected]
    if btn == "final"
      final_report(semester)
    elsif btn == "matters"
      matter_report(semester)
    else
      teacher_report(semester)
    end
    #render :index
  end

  def select_teacher
    puts "Group id: #{params[:id]}"
    @group = Group.find(params[:id])
    @group_id = params[:id]

    respond_to do |format|
      format.js
    end
  end

  def edit_teacher
    @group = Group.find(params[:id])
    #@group.ficha.destroy
    #@group.save
    respond_to do |format|
      format.js
    end
  end

  def choose_teacher
    @user = User.find(params[:user])
    @group = Group.find(params[:group])
    class_room = params[:class_room]
    @group.class_room = class_room
    @group.save

    if !@group.ficha.blank?
      if @group.ficha.user.id != @user.id
        @group.ficha.destroy
        @group.save
      end
    end

    if @group.ficha.blank?
        Ficha.create(user: @user, group: @group)
    end

    # send instructions to teacher via e-mail
    # Thread.new { UserMailer.notify_record(@user, @group).deliver }

    respond_to do |format|
      format.js
    end

  end

  def send_ficha2_email
    Ficha.all.each do |f|
      if f.group.semester.id == Semester.current_semester.id
        Thread.new { UserMailer.notify_record(f.user, f.group).deliver }
      end
    end
    render :index
  end

  private

    def bar_define
      session[:page] = "options"
    end

    def options_status(condition, generated, selection, finished)
      if condition
        @semester.options_generated = generated;
        @semester.options_selection = selection;
        @semester.options_finished = finished;
        @semester.save
      end
    end

    def generate_method
      Group.where(semester_id: Semester.current_semester.id).each do |group|
        option_generate(group)
      end
    end

    def option_generate(group)
      if !has_option_group(group.id)
        option = Option.new
        option.semester = Semester.current_semester

        group.same_groups.each do |same_group|
          option.groups << same_group
        end

        option.save
      end
    end

    def has_option_group(group_id)
      options = select_result(select_options_group(group_id))
      options.length > 0
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

    def set_semester
      @semester = Semester.current_semester
    end

    def authorize_user
      authorize ManageOptions
    end

end
