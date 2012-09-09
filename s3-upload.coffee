previewFile = (file) ->
  reader = new FileReader()
  el = $('<li class="span3"><div class="thumbnail"><a href="#"><img class="img-rounded"></a><div class="caption"><h3>' + file.name + '</h3><div class="progress progress-striped"><div class="bar" style="width: 0%;"></div></div><p></p></div></div></li>')
  $("#previews").append(el)
  img = $("img", el)
  progress = $("progress", el)
  reader.onload = (e) ->
    img.attr('src', e.target.result)
  reader.readAsDataURL(file)
  el

getFormFieldsFor = (file) ->
  $.getJSON "/sign", { username: "demo", filename: file.name }

handleUploadProgress = (file, el, event) ->
  if event.lengthComputable
    percent = Math.floor((event.loaded / event.total) * 100)
    $(".progress", el)
      .toggleClass("active", true)
    $(".bar", el)
      .css("width": "#{percent}%")
    $(".caption p", el)
      .text("#{percent}% uploaded")

uploadFile = (file, el) ->
  if file.size > (3 * 1024 * 1024)
    $(".caption p", el)
      .text("Sorry, file's too big!")
  else
    getFormFieldsFor(file).success (json) ->
      fd = new FormData()
      fd.append(key, value) for key, value of json.fields
      fd.append('file', file)
      $(".caption p", el).text "Starting upload..."
      xhr = new XMLHttpRequest()
      xhr.upload.addEventListener "progress", ((e) -> handleUploadProgress(file, el, e)), false
      xhr.addEventListener "load", (e) ->
        if xhr.status == 204
          $(".progress", el)
            .removeClass("active")
            .removeClass("progress-striped")
            .addClass("progress-success")
          $(".caption p", el)
            .text("Upload complete! ")
            .append($("<a href=\"#{json.url + json.fields.key}\">View on S3</a>"))
        else
          $(".caption p", el)
            .text("Upload failed ☹")
      xhr.open "POST", json.url, true
      xhr.send(fd)

handleFileSelect = (e) ->
  files = e.target.files
  for file in files when file.type == "image/jpeg"
    el = previewFile(file)
    uploadFile(file, el)

$ ->
  $('#files').bind('change', handleFileSelect)
