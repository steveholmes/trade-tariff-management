window.___modal_count = 0;

var template = [
  '<div :id="\'modal-\' + id" aria-hidden="true" class="modal">',
    '<div tabindex="-1" class="modal__overlay">',
      '<div role="dialog" class="modal__container" aria-modal="true" aria-labelledby="\'modal-\' + id + \'-title\'" >',
        '<header class="modal__header">',
          '<h2 id="\'modal-\' + id + \'-title\'" class="modal__title">',
            '<slot name="title"></slot>',
          '</h2>',
        '</header>',

        '<div class="modal__content">',
          '<slot></slot>',
        '</div>',
      '</div>',
    '</div>',
  '</div>'
].join("");

Vue.component("pop-up", {
  template: template,
  props: ["onClose", "open"],
  data: function() {
    return {
      id: (++window.___modal_count)
    };
  },
  mounted: function() {
    var self = this;

    MicroModal.init({
      onClose: function() {

        if (self.onClose) {
          self.onClose();
        }
      }
    });

    if (this.open) {
      MicroModal.show("modal-" + this.id);
    }

  },
  watch: {
    open: function (newVal, oldVal) {
      if (!oldVal && newVal) {
        MicroModal.show("modal-" + this.id);
      } else {
        MicroModal.close("modal-" + this.id);
      }
    }
  }
});