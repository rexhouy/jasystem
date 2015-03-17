(function() {
  var TABLE_ID, initTemplate, printer, template;

  TABLE_ID = "#doors_info";

  template = null;

  initTemplate = function() {
    if (template) {
      return template;
    }
    template = $(TABLE_ID + " > tbody tr:first-child").clone();
    return template.find("input").each(function() {
      return this.value = "";
    });
  };

  window.addDoor = function() {
    return $(TABLE_ID + " > tbody").append(template.clone());
  };

  window.removeDoor = function(btn) {
    return $(btn).parent().parent().remove();
  };

  window.prepareData = function() {
    var setName;
    setName = function(index, that) {
      return $(that).attr("name", $(that).attr("name").replace(/[0]/, "[" + index + "]"));
    };
    return $(TABLE_ID + " > tbody > tr").each(function(index) {
      $(this).find("input").each(function() {
        return setName(index, this);
      });
      return $(this).find("select").each(function() {
        return setName(index, this);
      });
    });
  };

  printer = function() {
    var self;
    self = {};
    self.loadData = function(id) {
      return $.get("/orders/" + id + "/print", function(data) {
        return console.log(data);
      });
    };
    return self;
  };

  $(function() {
    initTemplate();
    return $("#print_btn").click(function() {
      return printer().loadData(3);
    });
  });

}).call(this);
