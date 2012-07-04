class QuotaOrderNumberOrigin < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :geographical_area
end
