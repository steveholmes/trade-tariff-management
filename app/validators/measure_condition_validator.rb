class MeasureConditionValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MCD1, 'Condition code can not be blank.', on: [:create, :update] do
    validates :presence, of: :condition_code
  end

  validation :ME56, "The referenced certificate must exist.",
    on: [:create, :update],
    if: ->(record) { record.certificate_type_code.present? || record.certificate_code.present? } do |record|
      record.certificate.present?
    end

end
