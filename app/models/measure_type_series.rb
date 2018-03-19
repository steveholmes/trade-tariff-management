class MeasureTypeSeries < Sequel::Model
  set_primary_key [:measure_type_series_id]
  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  one_to_many :measure_types

  one_to_one :measure_type_series_description, key: :measure_type_series_id,
                                        foreign_key: :measure_type_series_id

  delegate :description, to: :measure_type_series_description

  def record_code
    "140".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
