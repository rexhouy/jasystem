# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.attr = (() ->
  self = {}

  self.getParents = () ->
    kind = $("#attribute_kind").val();
    $.get("/attributes", { kind : kind }).done((value) ->
      $("#parent").html("<option>请选择</option>")
      value.forEach((v) ->
        $("#parent").append("<option value="+v.id+">"+v.name+"</option>")))

  self)()
