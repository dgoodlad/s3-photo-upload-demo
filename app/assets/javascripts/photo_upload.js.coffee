previewFile = (file) ->
  reader = new FileReader()
  el = $('<div class="span2 thumbnail"><img><div class="caption">' + file.name + '</div></div>')
  $("#previews").append(el)
  img = $("img", el)
  progress = $("progress", el)
  reader.onload = (e) ->
    img.attr('src', e.target.result)

  reader.readAsDataURL(file)

getFormFieldsFor = (file) ->
  $.getJSON "/sign", { username: "demo", filename: file.name }

uploadFile = (file) ->
  getFormFieldsFor(file).success (json) ->
    fd = new FormData()
    fd.append(key, value) for key, value of json.fields
    fd.append('file', file)
    console.log fd
    request = $.ajax(
      url: json.url,
      type: "POST",
      data: fd,
      processData: false,
      contentType: false,
      cache: false
    )
    request.done (data) ->
      console.log request
      console.log data
      console.log json.url

uploadFiles = (files) ->
  uploadFile(file) for file in files when file.type == "image/jpeg"

handleFileSelect = (e) ->
  files = e.target.files
  previewFile(file) for file in files when file.type == "image/jpeg"
  uploadFiles(files)

$ ->
  $('#files').bind('change', handleFileSelect)
