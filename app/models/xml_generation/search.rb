module XmlGeneration
  class Search

    SEQUENCE_OF_DATA_FETCH = [
      GeographicalArea,
      GeographicalAreaDescription,
      GeographicalAreaDescriptionPeriod,
      GeographicalAreaMembership,

      MonetaryUnit,
      MonetaryUnitDescription,
      MonetaryExchangePeriod,
      MonetaryExchangeRate,

      MeasurementUnitQualifier,
      MeasurementUnitQualifierDescription,
      MeasurementUnit,
      MeasurementUnitDescription,
      Measurement,

      QuotaOrderNumber,
      QuotaOrderNumberOrigin,
      QuotaOrderNumberOriginExclusion,
      QuotaDefinition,
      QuotaAssociation,
      QuotaReopeningEvent,
      QuotaUnsuspensionEvent,
      QuotaUnblockingEvent,
      QuotaBalanceEvent,
      QuotaCriticalEvent,
      QuotaExhaustionEvent,
      QuotaSuspensionPeriod,
      QuotaBlockingPeriod,

      GoodsNomenclatureGroup,
      GoodsNomenclatureGroupDescription,
      GoodsNomenclature,
      GoodsNomenclatureDescription,
      GoodsNomenclatureDescriptionPeriod,
      GoodsNomenclatureIndent,
      GoodsNomenclatureOrigin,
      GoodsNomenclatureSuccessor,
      NomenclatureGroupMembership,

      MeasureTypeSeries,
      MeasureTypeSeriesDescription,
      MeasureType,
      MeasureTypeDescription,
      MeasureAction,
      MeasureActionDescription,
      Measure,
      MeasureComponent,
      MeasureConditionCode,
      MeasureConditionCodeDescription,
      MeasureCondition,
      MeasureConditionComponent,

      AdditionalCodeType,
      AdditionalCodeTypeDescription,
      AdditionalCodeTypeMeasureType,
      AdditionalCode,
      AdditionalCodeDescription,
      AdditionalCodeDescriptionPeriod,

      MeursingAdditionalCode,
      MeursingTablePlan,
      MeursingTableCellComponent,
      MeursingHeading,
      MeursingHeadingText,
      MeursingSubheading,

      DutyExpression,
      DutyExpressionDescription,

      CertificateType,
      CertificateTypeDescription,
      Certificate,
      CertificateDescription,
      CertificateDescriptionPeriod,

      RegulationRoleType,
      RegulationRoleTypeDescription,
      RegulationReplacement,
      RegulationGroup,
      RegulationGroupDescription,
      BaseRegulation,
      ModificationRegulation,
      CompleteAbrogationRegulation,
      ExplicitAbrogationRegulation,
      FullTemporaryStopRegulation,
      FtsRegulationAction,
      ProrogationRegulation,
      ProrogationRegulationAction,

      FootnoteType,
      FootnoteTypeDescription,
      Footnote,
      FootnoteDescription,
      FootnoteDescriptionPeriod,
      FootnoteAssociationAdditionalCode,
      FootnoteAssociationGoodsNomenclature,
      FootnoteAssociationMeasure,
      FootnoteAssociationMeursingHeading,

      ExportRefundNomenclature,
      ExportRefundNomenclatureDescription,
      ExportRefundNomenclatureDescriptionPeriod,
      ExportRefundNomenclatureIndent,

      Language,
      LanguageDescription,
      TransmissionComment,
      PublicationSigle
    ]

    attr_accessor :date, :mode

    def initialize(date, mode)
      @mode = mode
      @date = date.strftime("%Y-%m-%d")
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(data)
    end

    private

      def data
        SEQUENCE_OF_DATA_FETCH.map do |record_class|
          if mode == "samples"
            generate_samples(record_class)
          else
            fetch_relevant_data(record_class)
          end
        end.flatten
      end

      def generate_samples(record_class)
        record = record_class.order(
          Sequel.lit('RANDOM()')
        ).limit(1)
         .first

        [record]
      end

      def fetch_relevant_data(record_class)
        record_class.where("operation_date = ?", date).all
      end
  end
end