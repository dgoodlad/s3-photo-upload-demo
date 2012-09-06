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

handleUploadProgress = (file, event) ->
  if event.lengthComputable
    percent = Math.floor((event.loaded / event.total) * 100)
    console.log "#{file.name}: #{percent}% uploaded"

uploadFile = (file) ->
  getFormFieldsFor(file).success (json) ->
    fd = new FormData()
    fd.append(key, value) for key, value of json.fields
    fd.append('file', file)
    console.log "Uploading #{file.name}"
    xhr = new XMLHttpRequest()
    xhr.upload.addEventListener "progress", ((e) -> handleUploadProgress(file, e)), false
    xhr.addEventListener "load", (e) ->
      if xhr.status == 204
        console.log "Successfully uploaded #{file.name}"
      else
        console.log "Failed to upload #{file.name}: #{xhr.status}"
    xhr.open "POST", json.url, true
    xhr.send(fd)

uploadFiles = (files) ->
  uploadFile(file) for file in files when file.type == "image/jpeg"

handleFileSelect = (e) ->
  files = e.target.files
  previewFile(file) for file in files when file.type == "image/jpeg"
  uploadFiles(files)

$ ->
  $('#files').bind('change', handleFileSelect)
