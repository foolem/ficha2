class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy, :create_message, :copy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy, :copy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create, :import]
  before_action :bar_define

  def index
    @q = Ficha.ransack(model_define("Ficha"))
    @fichas = getFichas
    # @elements = @fichas.length
    #
    # @page = params[:page].to_i
    # @page = pages_verify(@page, @elements, (Ficha.all.count + 20))
    # @fichas = @fichas.paginate(:per_page => (Ficha.all.count + 20), :page => @page)

  end

  def search
    index
    render :index
  end

  def show
    pdf_generate
  end

  def new
    @ficha = Ficha.new
    @ficha.messages.build
  end

  def copy
    @message = Message.new
    ficha_new = Ficha.find(params[:copy_id])

    if(ficha_new.group.matter == @ficha.group.matter and (@ficha.user == current_user or current_user.admin?))

      @ficha.program = ficha_new.program
      @ficha.general_objective = ficha_new.general_objective
      @ficha.specific_objective = ficha_new.specific_objective
      @ficha.didactic_procedures = ficha_new.didactic_procedures
      @ficha.evaluation = ficha_new.evaluation
      @ficha.basic_bibliography = ficha_new.basic_bibliography
      @ficha.bibliography = ficha_new.bibliography

      if((user_signed_in? and current_user.admin?) and ficha_new.user.actived?)
        @ficha.user = ficha_new.user
      elsif(user_signed_in? and current_user.actived?)
        @ficha.user = current_user
      end
    else
      user_not_authorized
    end

  end

  def edit
    @message = Message.new
    @ficha.messages.build
    coppy_bibliography

  end

  #rever
  def coppy_bibliography

    if(@ficha.bibliography.blank?)
      @ficha.bibliography = @ficha.group.matter.bibliography
    end

    if(@ficha.basic_bibliography.blank?)
      @ficha.basic_bibliography = @ficha.group.matter.basic_bibliography
    end

  end

  def create
    @ficha = Ficha.new(new_params)
    coppy_bibliography

    respond_to do |format|
      if @ficha.save
        format.html { redirect_to @ficha, notice: 'Ficha foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @ficha }
      else
        format.html { render :new }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end

    end
  end

  def update
    list = edit_params

    puts "Current status: #{list[:status]}"

    if(current_user.teacher? && (!current_user.appraiser? && !current_user.admin?)  )
      if ficha_blank(Ficha.new(list))
        list[:status] = 'editing'
      else
        list[:status] = 'sent'
      end
    end

    respond_to do |format|
      if @ficha.update(list)
        format.html { redirect_to @ficha, notice: 'Ficha foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @ficha }
      else
        format.html { render :edit }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    if(!current_user.admin? && !current_user.secretary? && (@ficha.user.id != current_user.id))

      flash[:alert] = "Você não tem permissão para excluir esta ficha."
      redirect_to(request.referrer || root_path)

    else
      @ficha.destroy
      respond_to do |format|
        format.html { redirect_to fichas_url, notice: 'Ficha foi removida com sucesso.' }
        format.json { head :no_content }
      end

    end
  end

  def getFichas
    if !user_signed_in?
      @q.result.order(group_id: :desc).where(status: 2)

    elsif current_user.secretary?
      @q.result.order(group_id: :desc)

    else
      if(params[:checkbox])
        @q.result.order(status: :desc).where(user: current_user)
      else
        if current_user.appraiser?
          @q.result.order(status: :desc).where("status != 0")
        elsif current_user.admin?
          @q.result.order(status: :desc)
        else
          @q.result.order(group_id: :desc).where(status: 2)
        end
      end
    end
  end

  private

    def set_ficha
      @ficha = Ficha.find(params[:id])
    end

    def new_params
        params.require(:ficha).permit(:user_id, :group_id)
    end

    def edit_params
      if current_user.appraiser? and @ficha.user.id != current_user.id
        params.require(:ficha).permit(:status)

      else
        params.require(:ficha).permit(
          :program,
          :evaluation,
          :general_objective,
          :specific_objective,
          :didactic_procedures,
          :basic_bibliography,
          :bibliography,
          :status,
          messages_attributes: [:id, :_destroy, :message])
      end
    end

    def authorize_user
      authorize Ficha
    end

    def pdf_generate
      #https://www.youtube.com/watch?v=e-A3zBeWDdE

      respond_to do |format|
        format.html

        if(@ficha.ready?)
          format.pdf do
            pdf = RecordPdf.new(@ficha)
            send_data pdf.render,
              filename: "Ficha2 #{@ficha.group.matter.code} - #{@ficha.user.name}.pdf",
              type: "application/pdf",
              disposition: "inline"
          end
        else
          format.pdf { redirect_to @ficha, alert: 'Este documento ainda não esta pronto.' }
        end
      end
    end

    def ficha_blank(f)
      if(f.evaluation.blank? or f.program.blank? or f.bibliography.blank? or f.basic_bibliography.blank? or
         f.didactic_procedures.blank? or f.general_objective.blank? or f.specific_objective.blank?)
        true
      else
        false
      end
    end

    def page_length
        10
    end

    def bar_define
      session[:page] = "ficha"
    end

end
