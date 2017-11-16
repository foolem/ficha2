class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy, :open_wish]
  before_action :set_wish, only: [:open_unavailability_comment]
  before_action :set_semester
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

  def edit
  end

  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save

        format.html { redirect_to @option, notice: 'Opção foi criada com sucesso.' }
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
        format.html { redirect_to @option, notice: 'Opção foi atualizada com sucesso.' }
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
      format.html { redirect_to options_url, notice: 'Opção foi excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  def option_wish #   ????
    @wish = Wish.new(group_id: 1)
    respond_to do |format|
      format.js
    end
  end

  def open_unavailability_comment
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

    def set_semester
      @semester = Semester.current_semester
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

end
