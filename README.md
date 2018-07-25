# KomootTracker
This is small app that tracks your location and every 100 meters it fetches a photo from Flickr API. The result is that you get a nice overview of the route you did using public photos from Flickr.

To make it compile you just need to create a ```Credentials.swift``` file that declares a constant which is the Flickr api key:
```
let FLICKR_API_KEY = "your_key"
```

Then run ```pod install```and you are god to go.