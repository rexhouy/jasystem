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

  window.addDoor = () ->
    doors.add()

  window.removeDoor = (index) ->
    doors.remove(index)

  window.prepareData = () ->
    doors.prepareData()

  doors = (() ->
    self = {}
    index = 0
    ID_PREFIX = "#order_doors_attributes_"
    CONTAINER_ID = "#doors_container"
    NAME_TEMPLATE ="order[doors_attributes][#index][#field]"
    ID_TEMPLATE = "#order_doors_attributes_#index_#field"
    INPUT_TEMPLATE = "<input type='hidden' name='#name' value='#value'>"

    drawTemplate = (data) ->
      container = $(CONTAINER_ID)
      door = $ $("#doors_template").html().replace(/#index/g, index)
      index++
      if data?
        door.find(ID_PREFIX + index + "_material").val(data.material || "")
        door.find(ID_PREFIX + index + "_size_x").val(data.size_x || "")
        door.find(ID_PREFIX + index + "_size_y").val(data.size_y || "")
        door.find(ID_PREFIX + index + "_sill").val(data.sill || "")
        door.find(ID_PREFIX + index + "_count").val(data.count || "")
      door.appendTo container

    getFieldName = (field, index) ->
      return NAME_TEMPLATE.replace(/#index/g, index).replace(/#field/g, field)

    getFieldId = (field, index) ->
      return ID_TEMPLATE.replace(/#index/g, index).replace(/#field/g, field)

    newInput = (field, index) ->
      value = $(getFieldId(field, index)).val()
      $(INPUT_TEMPLATE.replace(/#name/, getFieldName(field, index)).replace(/#value/, value))

    self.init = () ->
      datas = eval $("#doors_info_data").html().replace(/&quot;/g, "")
      for data in datas
        drawTemplate data

    self.add = () ->
      drawTemplate()

    self.remove = (btn) ->
      $(btn).parent().remove() if $(CONTAINER_ID + " > div").size() > 1

    self.prepareData = () ->
      container = $(CONTAINER_ID)
      for i in [0..index]
        continue if !$(getFieldId("material", i))[0]?
        container.append(newInput("material", i))
        container.append(newInput("size_x", i))
        container.append(newInput("size_y", i))
        container.append(newInput("sill", i))
        container.append(newInput("count", i))

    return self
  )()

  # Register listeners
  $ () ->
    return if !$("#customer_next")[0]?
    ps = panels "#customer_info", "#order_info", "#other_info"
    $("#customer_next").click ps.next
    $("#order_next").click ps.next
    $("#order_prev").click ps.prev
    $("#other_prev").click ps.prev
    $("#add_bathroom_door").click addDoor
    doors.init()
