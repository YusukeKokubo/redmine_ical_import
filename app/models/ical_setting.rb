class IcalSetting < ActiveRecord::Base
    unloadable

    STATUS_ACTIVE = 1
    STATUS_LOCK = 9

    belongs_to :project
    belongs_to :tracker
    belongs_to :user

    def status_to_s
      case self.status
      when STATUS_ACTIVE
        "active"
      when STATUS_LOCK
        "lock"
      else
        "unkwnon"
      end
    end
end

