(function() {
  var displayUploadProgress, getFormFieldsFor, handleFileSelect, previewFile, uploadFile;

  previewFile = function(file) {
    var el, img, progress, reader;
    reader = new FileReader();
    el = $('<li class="span3"><div class="thumbnail"><a href="#"><img class="img-rounded"></a><div class="caption"><h3>' + file.name + '</h3><div class="progress progress-striped"><div class="bar" style="width: 0%;"></div></div><p></p></div></div></li>');
    $("#previews").append(el);
    img = $("img", el);
    progress = $("progress", el);
    reader.onload = function(e) {
      return img.attr('src', e.target.result);
    };
    reader.readAsDataURL(file);
    return el;
  };

  getFormFieldsFor = function(file) {
    return $.getJSON("/sign", {
      username: "demo",
      filename: file.name
    });
  };

  displayUploadProgress = function(el, event) {
    var percent;
    if (event.lengthComputable) {
      percent = Math.floor((event.loaded / event.total) * 100);
      $(".progress", el).toggleClass("active", true);
      $(".bar", el).css({
        "width": "" + percent + "%"
      });
      return $(".caption p", el).text("" + percent + "% uploaded");
    }
  };

  uploadFile = function(file, el) {
    if (file.size > (3 * 1024 * 1024)) {
      return $(".caption p", el).text("Sorry, file's too big!");
    } else {
      return getFormFieldsFor(file).success(function(json) {
        var fd, key, value, xhr, _ref;
        fd = new FormData();
        _ref = json.fields;
        for (key in _ref) {
          value = _ref[key];
          fd.append(key, value);
        }
        fd.append('file', file);
        $(".caption p", el).text("Starting upload...");
        xhr = new XMLHttpRequest();
        xhr.upload.addEventListener("progress", (function(e) {
          return displayUploadProgress(el, e);
        }), false);
        xhr.addEventListener("load", function(e) {
          if (xhr.status === 204) {
            $(".progress", el).removeClass("active").removeClass("progress-striped").addClass("progress-success");
            return $(".caption p", el).text("Upload complete! ").append($("<a href=\"" + (json.url + json.fields.key) + "\">View on S3</a>"));
          } else {
            return $(".caption p", el).text("Upload failed ☹");
          }
        });
        xhr.open("POST", json.url, true);
        return xhr.send(fd);
      });
    }
  };

  handleFileSelect = function(e) {
    var el, file, files, _i, _len, _results;
    files = e.target.files;
    _results = [];
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      if (!(file.type === "image/jpeg")) {
        continue;
      }
      el = previewFile(file);
      _results.push(uploadFile(file, el));
    }
    return _results;
  };

  $(function() {
    return $('#files').bind('change', handleFileSelect);
  });

}).call(this);
