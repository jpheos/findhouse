class StopTime < ApplicationRecord
  self.primary_keys = [:stop_id, :trip_id]
  belongs_to :stop
end
