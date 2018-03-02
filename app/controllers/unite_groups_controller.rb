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
    if @unite_group.groups.length == 2
      groups = @unite_group.groups
      groups.each_cons(2) do |g, i|
        if g.name == i.name

          if g.course != i.course
            course = Course.where(name: "#{g.course.name}, #{i.course.name}").first
            if course.blank?
              course = Course.create(name: "#{g.course.name}, #{i.course.name}")
            end
          else
            course = g.course
          end

          g.active = false
          g.save
          i.active = false
          i.save

          group = Group.where(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

          if group.blank?
            group = Group.create(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
          end

          group.schedules = @group.schedules
          group.save
        else
          if g.course != i.course
            course = Course.where(name: "#{g.course.name}, #{i.course.name}").first
            if course.blank?
              course = Course.create(name: "#{g.course.name}, #{i.course.name}")
            end
          else
            course = g.course
          end

          g.active = false
          g.save
          i.active = false
          i.save

          group = Group.where(name: "#{g.name}, #{i.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

          if group.blank?
            group = Group.create(name: "#{g.name}, #{i.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
          end

          group.schedules = @group.schedules
          group.save
        end
      end

    end
    if @unite_group.groups.length == 3
      groups = @unite_group.groups
      groups.each_cons(3) do |g, i, h|
        if g.name == i.name
          if g.name == h.name

            if g.course != i.course
              course = Course.where(name: "#{g.course.name}, #{i.course.name}").first
              if course.blank?
                course = Course.create(name: "#{g.course.name}, #{i.course.name}")
              end
            else
              course = g.course
            end

            g.active = false
            g.save
            i.active = false
            i.save
            h.active = false
            h.save

            group = Group.where(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

            if group.blank?
              group = Group.create(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
            end

            group.schedules = @group.schedules
            group.save
          end
        else
          if g.course != i.course
            if g.course != h.course
              course = Course.where(name: "#{g.course.name}, #{i.course.name}, #{h.course.name}").first
              if course.blank?
                course = Course.create(name: "#{g.course.name}, #{i.course.name}, #{h.course.name}")
              end
            end
          else
            course = g.course
          end

          g.active = false
          g.save
          i.active = false
          i.save
          h.active = false
          h.save

          group = Group.where(name: "#{g.name}, #{i.name}, #{h.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

          if group.blank?
            group = Group.create(name: "#{g.name}, #{i.name}, #{h.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
          end

          group.schedules = @group.schedules
          group.save

        end
        group = Group.where(name: "#{g.name}, #{i.name}", matter_id: g.matter.id).first

        group.destroy

      end
    end
    respond_to do |format|
      format.js
    end
  end

  def remove
    @unite_group.groups.delete(@group)
    if @unite_group.groups.length == 2
      groups = @unite_group.groups
      groups.each_cons(2) do |g, i|
        if g.name == i.name

          if g.course != i.course
            course = Course.where(name: "#{g.course.name}, #{i.course.name}").first
            if course.blank?
              course = Course.create(name: "#{g.course.name}, #{i.course.name}")
            end
          else
            course = g.course
          end

          g.active = false
          g.save
          i.active = false
          i.save

          group = Group.where(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

          if group.blank?
            group = Group.create(name: g.name, matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
          end

          group.schedules = @group.schedules
          group.save
        else
          if g.course != i.course
            course = Course.where(name: "#{g.course.name}, #{i.course.name}").first
            if course.blank?
              course = Course.create(name: "#{g.course.name}, #{i.course.name}")
            end
          else
            course = g.course
          end

          g.active = false
          g.save
          i.active = false
          i.save

          group = Group.where(name: "#{g.name}, #{i.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}").first

          if group.blank?
            group = Group.create(name: "#{g.name}, #{i.name}", matter_id: g.matter.id, course_id: course.id, semester_id: Semester.current_semester.id, active: true, vacancies: "#{g.vacancies}+#{i.vacancies}")
          end


          group.schedules = @group.schedules
          group.save
        end
      end

    end
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
    if @unite_group.groups.length == 2
      @unite_group.groups.each_cons(2) do |a, b|
        group_a = Group.find(a.id)
        group_b = Group.find(b.id)

        group_a.active = true
        group_a.save
        group_b.active = true
        group_b.save

        course_united = Course.where(name: "#{a.course.name}, #{b.course.name}").first
        group_united = Group.where(name: "#{a.name}, #{b.name}", matter_id: a.matter.id, course_id: course_united.id).first

        if group_united.blank?
          group_united = Group.where(name: a.name, matter_id: a.matter.id, course_id: course_united.id).first
          group_united.destroy
        else
          group_united.destroy
        end
      end
    end

    if @unite_group.groups.length == 3
      @unite_group.groups.each_cons(3) do |a, b, c|
        group_a = Group.find(a.id)
        group_b = Group.find(b.id)
        group_c = Group.find(c.id)

        group_a.active = true
        group_a.save
        group_b.active = true
        group_b.save
        group_c.active = true
        group_c.save

        course_united = Course.where(name: "#{a.course.name}, #{b.course.name}, #{c.course.name}").first
        group_united = Group.where(name: "#{a.name}, #{b.name}, #{c.name}", matter_id: a.matter.id, course_id: course_united.id).first

        if group_united.blank?
          group_united = Group.where(name: a.name, matter_id: a.matter.id, course_id: course_united.id).first
          group_united.destroy
        else
          group_united.destroy
        end
      end
    end


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
