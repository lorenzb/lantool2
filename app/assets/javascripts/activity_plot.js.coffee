//= require graph.js

# stackoverflow.com/questions/3224834
# a and b are JS Date objecs
_MS_PER_DAY = 1000 * 60 * 60 * 24
date_difference_in_days = (a, b) ->
  # discard time and timezone information
  utcA = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate())
  utcB = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate())
  Math.floor (utcB - utcA) / _MS_PER_DAY

strip_time_from_date = (d) ->
  new Date(d.getFullYear(), d.getMonth(), d.getDate())

parse_all_activities = (obj) ->
  data = []
  if obj.children.length > 0
    for u in obj.children
      data.push({
        name:       $(u).attr('name')
        activities: parse_activity_of_user u
      })
  return data

parse_activity_of_user = (user) ->
  data = []
  if user.children.length > 0
    for a in user.children
      data.push({
        day:  new Date(Number($(a).attr('day')))
        hour: parseInt $(a).attr('hour')
        activity_count: parseInt $(a).attr('activity_count')
      })
  return data

onDraw = (ctx, data, starttime, endtime) ->
  ctx.fillStyle = 'rgba(0,0,255,0.05)'
  ctx.fillRect 0,0,ctx.canvas.width, ctx.canvas.height

  line_height = 20
  line_margin = 5
  x_axis_height  = 20
  name_col_width = 150

  plot_width = ctx.canvas.width - name_col_width - 1
  days = date_difference_in_days starttime, endtime
  day_width  = plot_width / days
  hour_width = day_width / 24
 
  # plot x axis (legend and vertical lines)
  ctx.font = 'normal 10pt sans'
  console.log "days: "+days
  for i in [0..days]
    x = name_col_width + i*day_width
    day = new Date(starttime)

    ctx.fillStyle = 'rgba(0,0,0,0.5)'
    ctx.fillRect x, 0, 1, ctx.canvas.height
    ctx.fillText day.toLocaleDateString(), x+10, x_axis_height
    day.setDate(starttime.getDate() + 1)

    ctx.fillStyle = 'rgba(0,0,0,0.1)'
    for i in [1..23]
      ctx.fillRect x + hour_width*i, x_axis_height+line_margin, 1, ctx.canvas.height
  
  # calculate max of all activities for scaling the plot
  max_activity = 0
  console.log data
  for u in data
    for a in u.activities
      if a.activity_count > max_activity and a.day >= starttime and a.day <= endtime
        max_activity = a.activity_count

  console.log "max_activity = "+max_activity

  # plot actual data 
  for u,i in data
    y = (i+1)*(line_height+line_margin)+x_axis_height+line_margin
    ctx.fillStyle = 'rgba(0,0,0,0.1)'
    ctx.fillRect 0, y-line_height, ctx.canvas.width, line_height
    
    ctx.fillStyle = 'rgba(0,0,0,1)'
    ctx.fillText u.name, 10, y-5

    ctx.fillStyle = 'rgba(0,0,0,1)'
    for a in u.activities
      if a.day >= starttime and a.day <= endtime
        day = date_difference_in_days starttime, a.day
        h = Math.max(1, line_height / max_activity * a.activity_count)
        ctx.fillRect name_col_width + day_width*day + hour_width*a.hour, y-h, hour_width, h

$ ->
  container = $('.activity_graph data')[0]
  if container
    data = parse_all_activities(container)
    if data
      starttime = strip_time_from_date (new Date(Number($(container).attr('starttime'))))
      endtime   = strip_time_from_date (new Date(Number($(container).attr('endtime'))))
      create_canvas $('.activity_graph canvas')[0], (ctx) -> onDraw ctx, data, starttime, endtime
    else
      alert 'keine Daten gefunden'
