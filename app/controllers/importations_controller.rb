class ImportationsController < ApplicationController
  before_action :bar_define
  before_action :authorize_user

  def groups
  end

  def courses
  end

  def verify_extension(file)
    file_extension = file.original_filename.partition('.').last
    if file_extension.to_s == "xlsx"
      return true
    else
      respond_to do |format|
        format.html { redirect_to (:back), notice: 'Somente são permitidos arquivos com a extensão xlsx.' }
      end
      return false
    end
  end

  def import_groups
    file = params[:file]
    if verify_extension(file)
      Importation.import_groups(params[:file])
      redirect_to root_url, notice: 'Turmas importadas.'
    end
  end

  def import_courses
    file = params[:file]
    if verify_extension(file)
      Importation.import_courses(params[:file])
      redirect_to root_url, notice: 'Cursos importados.'
    end
  end

  private

    def bar_define
      session[:page] = "Importation"
    end

    def authorize_user
      authorize Importation
    end



end
