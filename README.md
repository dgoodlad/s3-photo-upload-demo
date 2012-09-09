# S3 Photo Upload Demo

This is a simple demonstration of client-side image uploads to Amazon S3. It simulates the scenario where you have an S3 bucket to which you want your users to be able to upload photos directly, with a reasonable user experience beyond what's used to be possible with a simple form POST and redirect.

_Disclaimer_ I don't claim this is pretty code - it's just a prototype/demo of a few things that are now possible!

The AWS credentials used to upload to S3 are never exposed to the client-side, but the image data never has to be sent to the server. The client-side code makes a request to `/sign` which takes the requested username and filename, and returns a set of form fields, including a base64-encoded policy and a signature. These values are then used on the client-side when uploading the file.

## Live Demo

A demo is, at the time of this writing, available at http://s3-photo-upload-demo.throwawayapp.com/

## Server-Side

The server side is very straightforward (all in `app.rb`). `/sign` takes a username/filename combination (username is hardcoded to 'demo' atm) and returns some JSON:

```json
{
  "url": "http://my-bucket-name.s3.amazonaws.com/",
  "fields": {
    "AWSAccessKeyId": "AKIAI6C4JGWHT2C5PGLQ",
    "key": "demo/oversize.jpg",
    "policy":"eyJleHBpcmF0aW9uIj[...]",
    "signature":"Q0qlCXilt4dc[...]",
    "Content-Type":"image/jpeg",
    "acl":"public-read"
  }
}
```

These values tell the client-side where to post to, and what multipart-encoded fields to include in order to make a successful request to S3. I've used the official AWS gem to generate these values for simplicity, but it's not a hard problem to generate the policy and signature on your own if you'd like. The policy looks like gibberish but is just base64-encoded json, so I recommend having a closer look at it to fully understand what's being generated.

## Client-side

All of the client-side code is in `s3-upload.coffee` (which generates `public/s3-upload.js`). It's written to be very procedural, keeping the interesting bits together. Unless you're writing something trivial, I wouldn't use this code as-is in a real application: it's just a demonstration.

## Hacking

The easiest way to get this running locally:

```sh
cp dot-env.example .env
vim .env
# Start the server
foreman start -p 3000
```

Now navigate to `http://localhost:3000/` and you should be set to play.

If you're changing the coffeescript, make sure you run `rake assets:compile` afterwards to generate the javascript. This will become annoying if you're making serious changes, in which case I'd recommend setting up Guard or using the official coffeescript compiler's `-w` flag to continuously recompile it.
