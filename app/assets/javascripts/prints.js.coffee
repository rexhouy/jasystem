# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
FONT = "bold 14pt roboto sans serif monospace"

window.printer = () ->
        self = {}
        self.print = (data) ->
                $("#print_output_container").empty()
                data.forEach((d) ->
                        drawCover(d)
                        drawContent(d))
                window.print()

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
                        ["#{d.size_x} * #{d.size_y}", -265, 280], # size
                        ["#{d.sill} mm", -250, 350], # sill
                        [d.material, -22, 280], # material
                        ["#{d.glass_x} * #{d.glass_y}", -160, 350] # glass
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
                                        boxOuterX : { x : 190, y : 145 },
                                        boxInnerX : { x : 160, y : 220 },
                                        boxOuterY : { x : -80, y : -320 },
                                        boxInnerY : { x : -130, y : -225 },
                                        frameOuterX : { x : 550, y : 157 },
                                        frameInnerX : { x : 510, y : 210 },
                                        frameOuterY : { x : -95, y : 20 },
                                        frameInnerY : { x : -125, y : 100 },
                                        lockFrame : { x : 100, y : 45},
                                        lockBox : { x : 80, y : -245}
                                }
                        },
                        typeB : {
                                name : "size_page_img_b",
                                position : {
                                        boxOuterX : { x : 180, y : 182 },
                                        boxInnerX : { x : 160, y : 255 },
                                        boxOuterY : { x : -50, y : -320 },
                                        boxInnerY : { x : -100, y : -225 },
                                        frameOuterX : { x : 550, y : 192 },
                                        frameOuterY : { x : -45, y : 100 },
                                        lockFrame : { x : 100, y : 45},
                                        lockBox : { x : 80, y : -245}
                                }
                        }
                }

                typeImageRelation = {
                        "1.4" : "typeA",
                        "1.0" : "typeA",
                        "0.8" : "typeB",
                        "1.2" : "typeA"
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






TABLE_ID = "#doors_info"

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

validate = (datas) ->
        for data in datas
                for attr, value of data
                        unless value
                                alert("数据不完整")
                                return false
        true

getValue = (datas, name) ->
        for element, i in document.getElementsByName(name)
                 datas[i] = datas[i] || {}
                 datas[i][name] = element.value

getData = () ->
        datas = []
        getValue(datas, name) for name in ["material", "size_x", "size_y", "sill",  "count"]
        return null unless validate(datas)
        datas

config = {
        "0.8": {
                glass_x: 'size_x-212' # 玻璃宽
                glass_y: "size_y-sill-175" # 玻璃高
                border_inner_x: "size_x-85" # 框宽
                border_inner_y: "size_y-43" # 框高
                frame_outer_x: "size_x-208" # 扇外框宽
                frame_outer_y: "size_y-sill-33" # 扇外框高
                frame_inner_x: "size_x-208" # 扇内框宽
                frame_inner_y: "size_y-sill-33" # 扇内框高
                lock_frame: 997 # 锁(扇)
                lock_border: 1030 # 锁(框)
        },
        "1.0": {
                glass_x: "size_x-205" # 玻璃宽
                glass_y: "size_y-sill -173" # 玻璃高
                border_inner_x: "size_x-80" # 框宽
                border_inner_y: "size_y-40" # 框高
                frame_outer_x: "size_x-65" # 扇外框宽
                frame_outer_y: "size_y-sill-33" # 扇外框高
                frame_inner_x: "size_x-225" # 扇内框宽
                frame_inner_y: "size_y-sill-193" # 扇内框高
                lock_frame: 997 # 锁(扇)
                lock_border: 1030 # 锁(框)
        },
        "1.4": {
                glass_x: "size_x-240" # 玻璃宽
                glass_y: "size_y-sill-198" # 玻璃高
                border_inner_x: "size_x-108" # 框宽
                border_inner_y: "size_y-54" # 框高
                frame_outer_x: "size_x-83" # 扇外框宽
                frame_outer_y: "size_y-sill-46" # 扇外框高
                frame_inner_x: "size_x-259" # 扇内框宽
                frame_inner_y: "size_y-sill-222" # 扇内框高
                lock_frame: 997 # 锁(扇)
                lock_border: 1040 # 锁(框)
        },
        "1.2": {
                glass_x: "size_x-183" # 玻璃宽
                glass_y: "size_y-sill-155" # 玻璃高
                border_inner_x: "size_x-70" # 框宽
                border_inner_y: "size_y-35" # 框高
                frame_outer_x: "size_x-55" # 扇外框宽
                frame_outer_y: "size_y-sill-27" # 扇外框高
                frame_inner_x: "size_x-205" # 扇内框宽
                frame_inner_y: "size_y-sill-177" # 扇内框高
                lock_frame: 997 # 锁(扇)
                lock_border: 1030 # 锁(框)
          }
}

calculate = (data) ->
        conf = config[data.material]
        size_x = data.size_x
        size_y = data.size_y
        sill = data.sill
        for key, value of conf
                data[key] = eval(value)
        data


window.printDrawing = () ->
        datas = getData()
        return unless datas
        calculate(data) for data in datas
        printer().print(datas)

window.printGlass = () ->
        datas = getData()
        return unless datas
        calculate(data) for data in datas
        $("#print_output_container").empty()
        $("#print_output_container").append("<p>#{data.glass_x}  *  #{data.glass_y}</p>") for data in datas
        window.print()

$ () ->
        initTemplate()
