class Trip < ApplicationRecord
  self.primary_key = :trip_id
  has_many  :stop_times
end
