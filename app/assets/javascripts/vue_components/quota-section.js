Vue.component("quota-section", {
  template: "#quota-section-template",
  data: function() {
    return {
      section_types: [
        { id: "annual", label: "Annual" },
        { id: "bi_annual", label: "Bi-annual" },
        { id: "quarterly", label: "Quarterly" },
        { id: "monthly", label: "Monthly" },
        { id: "custom", label: "Custom" }
      ],
      periods: [
        // { id: "1_repeating", label: "1 year repeating"},
        { id: "1", label: "1 year" },
        { id: "2", label: "2 years" },
        { id: "3", label: "3 years" },
        { id: "4", label: "4 years" },
        { id: "5", label: "5 years" }
      ],
    };
  },
  props: ["section", "index"],
  methods: {
    emptyDutyExpression: function() {
      return clone({
        duty_expression_id: "01A",
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    },
    balanceForType: function(type) {
      if (type == "annual") {
        return "";
      } else if (type == "bi_annual") {
        return {
          semester1: "",
          semester2: ""
        };
      } else if (type == "quarterly") {
        return {
          quarter1: "",
          quarter2: "",
          quarter3: "",
          quarter4: ""
        };
      } else if (type == "monthly") {
        return {
          month1: "",
          month2: "",
          month3: "",
          month4: "",
          month5: "",
          month6: "",
          month7: "",
          month8: "",
          month9: "",
          month10: "",
          month11: "",
          month12: ""
        };
      } else if (type == "custom") {

      }
    },
    blankOpeningBalance: function(type) {
      return {
        balance: this.balanceForType(type),
        critical: false,
        criticality_threshold: 90,
        duty_expressions: [this.emptyDutyExpression()]
      };
    },
    resetOpeningBalances: function() {
      var newOpeningBalances = [];

      this.section.duty_expressions.splice(0, 100);

      if (!this.section.duties_each_period) {
        this.section.duty_expressions.push();
      }

      section.balance = this.balanceForType(this.section.type);

      if (this.section.period == "1" || this.section.period == "1_repeating") {
        newOpeningBalances.push(this.blankOpeningBalance(this.section.type));
      } else {
        var years = parseInt(this.section.period, 10);

        for (var i = 1; i <= years; i++) {
          newOpeningBalances.push(this.blankOpeningBalance(this.section.type));
        }
      }

      this.section.opening_balances = newOpeningBalances;
    }
  },
  computed: {
    disableStaged: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    disableCriticality: function() {
      var check = ["1_repeating"];

      if (this.section.type == "annual") {
        check.push("1");
      }

      return check.indexOf(this.section.period) > -1;
    },
    disableDuties: function() {
      var check = ["1_repeating"];

      if (this.section.type == "annual") {
        check.push("1");
      }

      return check.indexOf(this.section.period) > -1;
    },
    omitCriticality: function() {
      return window.all_settings.quota_is_licensed == "true";
    }
  },
  watch: {
    "disableCriticality": function(newVal, oldVal) {
      if (!oldVal && newVal) {
        this.section.staged = false;
        this.section.criticality_each_period = false;
        this.section.duties_each_period = false;
      }
    },
    "section.type": function(newVal, oldVal) {
      if (newVal && newVal != oldVal) {
        this.resetOpeningBalances();
      }
    },
    "section.period": function() {
      this.resetOpeningBalances();
    }
  }
});
