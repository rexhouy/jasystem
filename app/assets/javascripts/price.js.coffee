# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

attributes = []
initAttributes = () ->
  $("select[name=attribute]").each(() ->
    $(this).find("option").each(() ->
      if ($(this).val() == "0")
        return
      attr = $(this).val().split("_")
      attributes.push({
        id: attr[0],
        kind: attr[1],
        name: attr[2],
        price: attr[3]   })
      attributes))

$(() ->
  return if ($("#price").val() != "true")
  initAttributes())

window.price = (() ->
  self = {}
  self.compute = () ->
    subTotal = 0
    $("select[name=attribute]").each(() ->
      subTotal += Number(this.value))
    $("#subTotal").html("&#165;&nbsp;" + subTotal);

  self.change = (t) ->
    $(t).parent().next().find("select").each(() ->
      $(this).hide())
    $("#"+$(t).val()).show()
  self)()
