# graph drawing library

text = (ctx, text, x, y, bold=false) ->
  ctx.font = '14pt Sans'
  ctx.font = 'bold 14pt Sans' if bold
  ctx.textBaseline = 'top'
  ctx.textAlign    = 'left'
  ctx.fillStyle    = 'rgba(0,0,0,1)'
  ctx.fillText text, x, y

@_CANVAS_HEIGHT = 500

@parse_options = (obj) ->
  data = []
  if obj.children.length > 0
    for c in obj.children
      t = $(c).attr 'text'
      v = parseInt $(c).attr('votes')
      data.push({
        votes: v
        y:     v
        text:  t
        name:  t
        #color: $(c).attr 'color'
      })
  return data

@draw_bar_chart = (ctx, options) ->
  sum = 0
  sum += o.votes for o in options

  if options.length == 0
    text ctx, "Keine Daten verfügbar", 10, 100, true
  else
    x = 0
    for o in options
      if o.votes > 0
        percent = Math.round ( 100 * o.votes / sum )
        w = o.votes / sum * ctx.canvas.width

        ctx.fillStyle = o.color
        ctx.fillRect x+1, 0, w-2, ctx.canvas.height

        ctx.textBaseline = 'bottom'
        ctx.font = 'normal 10pt Sans'
        ctx.fillStyle = 'rgba(0,0,0,1)'
        ctx.fillText percent+"%", x+10, ctx.canvas.height-10

        ctx.font = 'bold 14pt Sans'
        ctx.fillText o.text,      x+10, ctx.canvas.height-20-5
        x += w

# create canvas if it's a canvas obj
# maintain aspect ratio and replot on resizes
@create_canvas = (obj, onDraw) ->
  if obj.getContext
    ctx = obj.getContext '2d'
    onResize = (ctx) ->
      ctx.canvas.width        = ctx.canvas.clientWidth
      # maintain 4:3 aspect ratio
      # ctx.canvas.height       = ctx.canvas.clientWidth * 3 / 4
      ctx.canvas.height = @_CANVAS_HEIGHT
      onDraw ctx
    onResize ctx
    window.addEventListener 'resize', -> onResize ctx
