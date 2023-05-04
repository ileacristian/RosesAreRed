# RosesAreRed

![Alt Text](https://user-images.githubusercontent.com/705971/184415511-3c9efae3-01fd-4a4c-bb5d-3cacfcf57bce.gif)

This is a demo iOS project that uses SwiftUI and Combine exclusivelly. I use this project to test various things.
The architecture is inspired by MVVM.

The project takes use of the CoreLocation and MapKit frameworks to draw a route from the user's current location to a destionation on the map.

The Map is drawn usingn a bridging API between UIKit and SwiftUI.

The app makes HTTP requests to https://www.mockable.io and it fetches the data from there and uses Codable to parse the JSON response into swift model structs.

It also has some automated UI Tests using XCUITest.

The project uses Github Actions as a CI/CD pipeline.

Third party dependencies are taken care of with SPM.
