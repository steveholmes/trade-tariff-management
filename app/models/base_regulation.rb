class BaseRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext

  plugin :oplog, primary_key: [:base_regulation_id, :base_regulation_role]
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:base_regulation_id, :base_regulation_role]

  include ::FormApiHelpers::RegulationSearch

  one_to_one :complete_abrogation_regulation, key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]

  def not_completely_abrogated?
    complete_abrogation_regulation.blank?
  end

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end

  def record_code
    "285".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def formatted_id
    year = Date.strptime(base_regulation_id.slice(1,2), "%y").strftime("%Y");
    number = base_regulation_id.slice(3,4)

    "#{year}/#{number}"
  end
end
