# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

TABLE_ID = "#doors_info"

template = null
initTemplate = () ->
  return template if template
  # Use the first line as a template
  template = $(TABLE_ID + " > tbody tr:first-child").clone()
  template.find("input").each(() ->
    this.value = "")

window.addDoor = () ->
  $(TABLE_ID + " > tbody").append(template.clone())

window.removeDoor = (btn) ->
  $(btn).parent().parent().remove()

window.prepareData = () ->
  setName = (index, that) ->
    $(that).attr("name", $(that).attr("name").replace(/[0]/, "[#{index}]"))

  $(TABLE_ID + " > tbody > tr").each((index) ->
    $(this).find("input").each(() -> setName(index, this))
    $(this).find("select").each(() -> setName(index, this)))

$ () ->
  initTemplate()
