class IcalEvent < ActiveRecord::Base
    unloadable
    belongs_to :issue
    belongs_to :ical_setting
end

