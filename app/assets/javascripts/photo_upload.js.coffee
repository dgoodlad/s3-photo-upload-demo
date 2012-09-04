previewFile = (file) ->
  reader = new FileReader()
  el = $('<div class="span2 thumbnail"><img><div class="caption">' + file.name + '</div></div>')
  $("#previews").append(el)
  img = $("img", el)
  progress = $("progress", el)
  reader.onload = (e) ->
    img.attr('src', e.target.result)

  reader.readAsDataURL(file)

handleFileSelect = (e) ->
  files = e.target.files
  previewFile(file) for file in files when file.type == "image/jpeg"

$ ->
  $('#files').bind('change', handleFileSelect)
