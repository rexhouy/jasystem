# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

TABLE_ID = "#doors_info"
FONT = "bold 14pt sans serif monospace"

template = null
initTemplate = () ->
        return template if template?
        # Use the first line as a template
        template = $(TABLE_ID + " > tbody tr:first-child").clone()
        return null unless template?
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

printer = () ->
        self = {}
        self.print = () ->
                loadData($("#order_id").val(), (data) ->
                        data.forEach((d) ->
                                drawCover(d)
                                drawContent(d))
                        window.print())
        loadData = (id, func) ->
                $.get "/orders/#{id}/print", func

        getCanvas = () ->
                canvas = $($("#canvas_template").html())
                canvas.appendTo($("#print_output_container"))
                canvas.find("canvas")[0]

        drawCover = (d) ->
                canvas = getCanvas()
                ctx = canvas.getContext("2d")
                ctx.drawImage($("#cover_page_img")[0],0,0)

                setFont = () ->
                        ctx.font = FONT

                drawText = (text, x, y) ->
                        ctx.save()
                        metric = ctx.measureText(text)
                        ctx.translate(canvas.width/2, canvas.height/2)
                        ctx.rotate(Math.PI/2)
                        ctx.fillText(text, x, y)
                        ctx.restore()

                values = [
                        ["#{d.size_x} * #{d.size_y}", -265, 260], # size
                        ["#{d.sill} mm", -250, 325], # sill
                        [d.material, -22, 260], # material
                        ["#{d.glass_x} * #{d.glass_y}", -160, 325] # glass
                ]

                drawMaterialFrame = () ->
                        ctx.font = "bold 35pt sans serif monospace"
                        ctx.fillText(d.material, 410, 250)

                setFont()
                values.forEach ((value) ->
                        drawText(value[0], value[1], value[2]))
                drawMaterialFrame()

        drawContent = (d) ->
                images = {
                        typeA : {
                                name : "size_page_img_a",
                                position : {
                                        boxOuterX : { x : 200, y : 145 },
                                        boxInnerX : { x : 160, y : 220 },
                                        boxOuterY : { x : -80, y : -290 },
                                        boxInnerY : { x : -130, y : -195 },
                                        frameOuterX : { x : 550, y : 157 },
                                        frameInnerX : { x : 510, y : 210 },
                                        frameOuterY : { x : -95, y : 50 },
                                        frameInnerY : { x : -125, y : 130 },
                                        lockFrame : { x : 100, y : 75},
                                        lockBox : { x : 80, y : -215}
                                }
                        },
                        typeB : {
                                name : "size_page_img_b",
                                position : {
                                        boxOuterX : { x : 200, y : 182 },
                                        boxInnerX : { x : 160, y : 255 },
                                        boxOuterY : { x : -50, y : -290 },
                                        boxInnerY : { x : -100, y : -195 },
                                        frameOuterX : { x : 550, y : 192 },
                                        frameOuterY : { x : -45, y : 130 },
                                        lockFrame : { x : 100, y : 75},
                                        lockBox : { x : 80, y : -215}
                                }
                        }
                }

                typeImageRelation = {
                        "1.4" : "typeA",
                        "1.0" : "typeA",
                        "0.8" : "typeB"
                }

                findImage = (material) ->
                        type = typeImageRelation[String(material)]
                        images[type]

                setFont = () ->
                        ctx.font = FONT

                drawTextVertical = (text, x, y) ->
                        ctx.save()
                        metric = ctx.measureText(text)
                        ctx.translate(canvas.width/2, canvas.height/2)
                        ctx.rotate(-Math.PI/2)
                        ctx.fillText(text, x, y)
                        ctx.restore()

                drawTextHorizontal = (text, x, y) ->
                        ctx.fillText(text, x, y)

                image = findImage(d.material)
                canvas = getCanvas()
                ctx = canvas.getContext('2d')
                ctx.drawImage($("#"+image.name)[0],0,0)

                memos = [
                        {
                                text : d.size_x,
                                position : image.position.boxOuterX,
                                direction : "horizontal"
                        }, {
                                text : "下料尺寸 " + d.border_inner_x,
                                position : image.position.boxInnerX,
                                direction : "horizontal"
                        }, {
                                text : d.size_y,
                                position : image.position.boxOuterY,
                                direction : "vertical"
                        }, {
                                text : "下料尺寸 " + d.border_inner_y,
                                position : image.position.boxInnerY,
                                direction : "vertical"
                        }, {
                                text : d.frame_outer_x,
                                position : image.position.frameOuterX,
                                direction : "horizontal"
                        }, {
                                text : "下料尺寸 " + d.frame_inner_x,
                                position : image.position.frameInnerX,
                                direction : "horizontal"
                        }, {
                                text : d.frame_outer_y
                                position : image.position.frameOuterY,
                                direction : "vertical"
                        }, {
                                text : "下料尺寸 " + d.frame_inner_y,
                                position : image.position.frameInnerY,
                                direction : "vertical"
                        }, {
                                text :  d.lock_frame,
                                position : image.position.lockFrame,
                                direction : "vertical"
                        }, {
                                text :  d.lock_border,
                                position : image.position.lockBox,
                                direction : "vertical"
                        }
                ]

                drawMemos = () ->
                        memos.forEach ((memo) ->
                                if (memo.text && memo.position)
                                        drawMethod = if memo.direction == "horizontal" then drawTextHorizontal else drawTextVertical
                                        drawMethod.call(null, memo.text, memo.position.x, memo.position.y))

                setFont()
                drawMemos()

        self


$ () ->
        initTemplate()
        $("#print_btn").click () ->
                printer().print()
