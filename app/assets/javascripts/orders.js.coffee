# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Handle prev next button
panels = (ids...) ->
  self = {}
  ps = (jQuery id for id in ids)
  dispIndex = 0

  self.next = () ->
    return false if dispIndex == ps.length - 1
    ps[dispIndex].hide()
    ps[++dispIndex].show()

  self.prev = () ->
    return false if dispIndex == 0
    ps[dispIndex].hide()
    ps[--dispIndex].show()

  return self

addDoor = () ->
  template = $("#order_info > div").clone()
  template.find("input").each () ->
    this.value == ""
  $("#order_info > nav").before template

window.removeDoor = (btn) ->
  self = $(btn).parent()
  if $("#order_info > div").length == 1
    # Clear info
    self.find("input").each () ->
      this.value = ""
  else
    # Remove this
    self.remove()

# Register listeners
$ () ->
  ps = panels "#customer_info", "#order_info", "#other_info"
  $("#customer_next").click ps.next
  $("#order_next").click ps.next
  $("#order_prev").click ps.prev
  $("#other_prev").click ps.prev

  $("#add_bathroom_door").click addDoor
