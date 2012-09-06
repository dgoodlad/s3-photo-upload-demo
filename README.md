# S3 Photo Upload Demo

This is a simple demonstration of client-side image uploads to Amazon S3. It simulates the scenario where you have an S3 bucket to which you want your users to be able to upload photos directly, with a reasonable user experience beyond what's used to be possible with a simple form POST and redirect.

_Disclaimer_ I don't claim this is pretty code - it's just a prototype/demo of a few things that are now possible!

The AWS credentials used to upload to S3 are never exposed to the client-side, but the image data never has to be sent to the server. The client-side code makes a request to `/sign` which takes the requested username and filename, and returns a set of form fields, including a base64-encoded policy and a signature. These values are then used on the client-side when uploading the file.

## Server-Side

The interesting bits are:

* `app/models/photo_request.rb` -- Handles request pre-signing, keeping credentials private on the server-side
* `app/controllers/photo_upload_controller.rb` -- The main entry point to the server-side

## Client-side

All of the client-side code is in `app/assets/javascripts/photo_upload.js.coffee`.

