class IcalSetting < ActiveRecord::Base
    unloadable
    belongs_to :project
    belongs_to :tracker
    belongs_to :user
end

