class UidRelation < ActiveRecord::Base
    unloadable
    belongs_to :issue
end

