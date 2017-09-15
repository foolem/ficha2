class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :bar_define

  def index
    if(params[:q].blank? and !session[:courses_search].blank?)
      @query = session[:courses_search]
    else
      @query = params[:q]
      session[:courses_search] = params[:q]
    end

    @q = Course.ransack(@query)
    @page = params[:page].to_i
    @courses = @q.result.order(name: :desc)
    @elements = @courses.length

    @page = pages_verify(@page, @elements, 10)
    @courses = @courses.paginate(:per_page => 10, :page => @page)
  end

  def search
    index
    render :index
  end

  def show
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  # Arrumar
    if !Group.all.any? {|group| group.course_id = @course.id}
      @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Curso removido com sucesso." }
      end
    else
      respond_to do |format|
        format.html { redirect_to courses_url, alert: "Este curso não pode ser removido." }
      end
    end

  end

  private

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name)
    end

    def bar_define
      session[:page] = "courses"
    end
end
