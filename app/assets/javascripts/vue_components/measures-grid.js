Vue.component("measures-grid", {
  template: "#measures-grid-template",
  props: [
    "onSelectionChange",
    "onItemSelected",
    "onItemDeselected",
    "onSelectAllChanged",
    "data",
    "columns",
    "selectedRows",
    "clientSorting",
    "sortByChanged",
    "sortDirChanged",
    "selectionType"
  ],
  data: function() {
    var self = this;

    var selectAll = this.selectionType == 'all';

    return {
      sortBy: "measure_sid",
      sortDir: "desc",
      selectAll: selectAll,
      firstLoad: true,
      indirectSelectAll: false
    };
  },
  methods: {
    selectSorting: function(column) {
      var f = column.field;

      if (f == this.sortBy) {
        this.sortDir = this.sortDir === "asc" ? "desc" : "asc";
      } else {
        this.sortDir = "desc";
        this.sortBy = f;
      }
    },
    sendCheckedTrigger: function(event) {
      if (event.target.checked) {
        this.onItemSelected(parseInt(event.target.value, 10));
      } else {
        this.onItemDeselected(parseInt(event.target.value, 10));
      }
    },
    findColumn: function(field) {
      for (var k in this.columns) {
        var o = this.columns[k];

        if (o.field == field) {
          return o;
        }
      }
    },
    getSortingFunc: function() {
      var column = this.findColumn(this.sortBy);
      var sortBy = this.sortBy;

      switch (column.type) {
        case "number":
          return function(a, b) {
            return parseInt(a[sortBy], 10) - parseInt(b[sortBy], 10);
          };
        case "string":
          return function(a, b) {
            return a - b;
          };
        case "date":
          return function(a, b) {
            return a - b;
          }
      }
    }
  },
  computed: {
    enabledColumns: function() {
      return this.columns.filter(function(c) {
        return c.enabled;
      });
    },
    sorted: function() {
      if (!this.clientSorting) {
        return this.data;
      }

      var sortDir = this.sortDir;
      var sortFunc = this.getSortingFunc();
      var result = this.data.slice().sort(sortFunc);

      if (sortDir === "asc") {
        return result;
      }

      return result.reverse();
    }
  },
  watch: {
    sortDir: function(val) {
      if (this.sortDirChanged) {
        this.sortDirChanged(val);
      }
    },
    sortBy: function(val) {
      if (this.sortByChanged) {
        this.sortByChanged(val);
      }
    },
    selectAll: function(val) {
      var self = this;

      if (this.indirectSelectAll) {
        return;
      }

      if (this.onSelectAllChanged) {
        this.onSelectAllChanged(val);
        return;
      }

      if (val) {
        this.data.map(function(row) {
          self.onItemSelected(row.measure_sid);
        });
      } else {
        this.data.map(function(row) {
          self.onItemDeselected(row.measure_sid);
        });
      }
    },
    selectedRows: function(newVal, oldVal) {
      var self = this;

      if (!this.onSelectAllChanged) {
        this.indirectSelectAll = true;

        this.selectAll = this.data.map(function(m) {
          return self.selectedRows.indexOf(m.measure_sid) === -1;
        }).filter(function(b) {
          return b;
        }).length === 0;

        setTimeout(function() {
          self.indirectSelectAll = false;
        }, 50);
      }

      if (this.onItemSelected) {
        newVal.forEach(function(m) {
          if (oldVal.indexOf(m) === -1) {
            self.onItemSelected(m);
          }
        });
      }

      if (this.onItemDeselected) {
        oldVal.forEach(function(m) {
          if (newVal.indexOf(m) === -1) {
            self.onItemDeselected(m);
          }
        });
      }
    }
  }
})
