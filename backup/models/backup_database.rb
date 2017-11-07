# encoding: utf-8

##
# Backup Generated: backup_database
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t backup_database [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:backup_database, 'Realiza backup do banco de dados') do

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "ficha2_production"
    db.username           = "root"
    db.password           = "admin"
    db.host               = "localhost"
    db.port               = 3306
    # Note: when using `skip_tables` with the `db.name = :all` option,
    # table names should be prefixed with a database name.
    # e.g. ["db_name.table_to_skip", ...]

    db.additional_options = ["--quick", "--single-transaction"]
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 10
    # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "ficha2.mat@gmail.com"
    mail.to                   = "ficha2.mat@gmail.com"
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = "Ficha2"
    mail.user_name            = "ficha2.mat@gmail.com"
    mail.password             = "passwdubuntu"
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
