# KomootTracker

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/aa73cfa8bced4e54b79232fa1b401717)](https://app.codacy.com/manual/pau.ballart/KomootTracker?utm_source=github.com&utm_medium=referral&utm_content=pballart/KomootTracker&utm_campaign=Badge_Grade_Dashboard)

This is small app that tracks your location and every 100 meters it fetches a photo from Flickr API. The result is that you get a nice overview of the route you did using public photos from Flickr.

To make it compile you just need to create a ```Credentials.swift``` file that declares a constant which is the Flickr api key:
```
let FLICKR_API_KEY = "your_key"
```

Then run ```pod install```and you are god to go.