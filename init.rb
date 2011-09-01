require 'redmine'
require 'dispatcher'

require 'ical_import_projects_helper_patch'

Redmine::Plugin.register :ical_import do
  name 'Redmine ical import plugin'
  author 'Yusuke Kokubo'
  description 'create issues by ical events'
  version '0.0.1'
  requires_redmine :version_or_higher => '1.2.0'

  project_module :ical_import do
    permission :ical_import_setting, {:ical_import_settings => [:show, :new]}
  end

end

