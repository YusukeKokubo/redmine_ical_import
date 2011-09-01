require_dependency 'projects_helper'

module IcalImportProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, ProjectsHelperMethodsIcalImport)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :project_settings_tabs, :ical_import
    end

  end
end

module ProjectsHelperMethodsIcalImport
  def project_settings_tabs_with_ical_import
    tabs = project_settings_tabs_without_ical_import
    action = {:name => 'ical_import', :controller => 'ical_import_settings', :action => :show, :partial => 'ical_import_settings/show', :label => :ical}

    tabs << action if User.current.allowed_to?(action, @project)

    tabs
  end
end

ProjectsHelper.send(:include, IcalImportProjectsHelperPatch)
