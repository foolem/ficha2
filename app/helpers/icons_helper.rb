module IconsHelper

  def big_download_button
    '<i class="glyphicon glyphicon-save big-btn-align"></i>'
  end

  def big_trash_button
    '<i class="glyphicon glyphicon-trash big-btn-align"></i>'
  end

  def big_play_button
    '<i class="glyphicon glyphicon-play-circle big-btn-align"></i>'
  end

  def big_stop_button
    '<i class="glyphicon glyphicon-stop big-btn-align"></i>'
  end

  def big_generate_button
    '<i class="glyphicon glyphicon-cog big-btn-align"></i>'
  end

  def remove_button
    '<i class="glyphicon glyphicon-remove"></i>'
  end

  def enable_button
    '<i class="glyphicon glyphicon-off"></i>'
  end

  def desable_button
    '<i class="glyphicon glyphicon-off"></i>'
  end

  def edit_button
    '<i class="glyphicon glyphicon-edit"></i> Editar'
  end

  def simple_edit_button
    '<i class="glyphicon glyphicon-edit"></i>'
  end

  def new_button
    '<i class="glyphicon glyphicon-plus"></i>'
  end

  def download_button
    '<i class="glyphicon glyphicon-save"></i> Baixar'
  end

  def show_button
    '<i class="glyphicon glyphicon-eye-open"></i>'
  end

  def duplicate_button
    '<i class="glyphicon glyphicon-duplicate"></i>'
  end

  def search_button
    '<i class="glyphicon glyphicon-search"></i>'
  end

  def back_button
    '<i class="glyphicon glyphicon-arrow-left"></i>'
  end

  def config_button
    '<i class="glyphicon glyphicon-cog"></i>'
  end

  def reload_button
    '<i style="color: greeen" class="glyphicon glyphicon-refresh"></i> Atualizar'
  end

  def help_button
    '<i class="glyphicon glyphicon-pushpin"></i>'
  end

  def messages_button
    '<i class="glyphicon glyphicon-envelope"></i>'
  end

  def question_button
    '<i class="glyphicon glyphicon-info-sign"></i>'
  end

  def check_button
    '<i class="glyphicon glyphicon-ok blue"></i>'
  end

  def simple_check_button
    '<i class="glyphicon glyphicon-ok white"></i>'
  end


  def send_button
    messages_button + " Enviar"
  end

  def user_button(user)
    '<i class="glyphicon glyphicon-user"></i> ' + user
  end

  def ok_icon
    'ok'
  end

  def backups_icon
    'export'
  end

  def home_icon
    'home'
  end

  def ficha_icon
    'list-alt'
  end

  def matter_icon
    'tags'
  end

  def group_icon
    'list'
  end

  def user_icon
    'user'
  end

  def course_icon
    'education'
  end

  def option_icon
    'check'
  end

  def unite_matters_icon
    'resize-small'
  end

  def unite_groups_icon
    'resize-small invert'
  end

  def help_icon
    'envelope'
  end

  def account_icon
    'cog'
  end

  def schedule_icon
    'time'
  end

  def wish_icon
    'time'
  end

  def menu_icon(key)
    "pull-right hidden-sm showopacity  menu-font-size glyphicon glyphicon-#{key}"
  end

  def index_icon(key)
    "glyphicon glyphicon-#{key} blue"
  end

 end
