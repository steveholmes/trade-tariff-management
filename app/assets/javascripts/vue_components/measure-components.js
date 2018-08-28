//= require ../components/duty-expressions-parser

var componentCommonFunctionality = {
  computed: {
    showMonetaryUnit: function() {
      return false;
    }
  },
  methods: {
    expressionsFriendlyDuplicate: function(options) {
      return DutyExpressionsParser.parse(options);
    },
    onDutyExpressionSelected: function(item) {
      this[this.thing].duty_expression = item;

      if (!this.showMonetaryUnit) {
        this[this.thing].monetary_unit = null;
        this[this.thing].monetary_unit_code = null;
      }

      if (!this.showMeasurementUnit) {
        this[this.thing].measurement_unit_code = null;
        this[this.thing].measurement_unit_qualifier_code = null;
        this[this.thing].measurement_unit = null;
        this[this.thing].measurement_unit_qualifier = null;
      }
    },
    onMonetaryUnitSelected: function(item) {
      this[this.thing].monetary_unit = item;
    },
    onMeasurementUnitSelected: function(item) {
      this[this.thing].measurement_unit = item;
    },
    onMeasurementUnitQualifierSelected: function(item) {
      this[this.thing].measurement_unit_qualifier = item;
    }
  }
};

Vue.component("measure-component", $.extend({}, {
  template: "#measure-component-template",
  props: [
    "measureComponent",
    "index",
    "hideHelp",
    "roomDutyAmountOrPercentage",
    "roomDutyAmountPercentage",
    "roomDutyAmountNegativePercentage",
    "roomDutyAmountNumber",
    "roomDutyAmountMinimum",
    "roomDutyAmountMaximum",
    "roomDutyAmountNegativeNumber",
    "roomDutyRefundAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureComponent"
    };
  }
}, componentCommonFunctionality));

Vue.component("measure-condition-component", $.extend({}, {
  template: "#measure-condition-component-template",
  props: [
    "measureConditionComponent",
    "index",
    "hideHelp",
    "roomDutyAmountOrPercentage",
    "roomDutyAmountPercentage",
    "roomDutyAmountNegativePercentage",
    "roomDutyAmountNumber",
    "roomDutyAmountMinimum",
    "roomDutyAmountMaximum",
    "roomDutyAmountNegativeNumber",
    "roomDutyRefundAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureConditionComponent"
    };
  },
  computed: {
    hideHelp: function() {
      return this.index > 0;
    }
  }
}, componentCommonFunctionality));
