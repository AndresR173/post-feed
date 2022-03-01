# Post feed
![](https://badges.fyi/github/latest-tag/AndresR173/post-feed)
![](https://badges.fyi/github/stars/AndresR173/post-feed)
![](https://badges.fyi/github/license/AndresR173/post-feed)
![GitHub Build Status](https://github.com/AndresR173/ShopApp/workflows/Swift/badge.svg)
[![codecov](https://codecov.io/gh/AndresR173/ShopApp/branch/main/graph/badge.svg?token=8H3F0HWP4M)](https://codecov.io/gh/AndresR173/post-feed)

A post feed powered by JsonPlaceholder and Core Data.

## Getting Started

This project uses `SwiftLint` to enforce Swift style and conventions. To run this project, please use Xcode 13.0 and iOS 14.0+.

### Using [Homebrew](http://brew.sh/):
```
brew install swiftlint
```

## Project details

### Architecture
This project uses MVVM as architectural design pattern.

### UI
There is a mix of UI concepts. The main view (Post feed) uses XIB files for the layout. The post details screen uses programmatic UI.
## API
This project uses [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) for all HTTP requests.
The networking is handled by [NSURLSession](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine) and Combine.

## Third party dependencies

- [Lottie](https://github.com/airbnb/lottie-ios)
- [Swinject](https://github.com/Swinject/Swinject)

## Demo
![demo](https://github.com/AndresR173/post-feed/blob/main/post-feed.gif)

 License
 ----


MIT License

Copyright (c) 2021 Andres Rojas

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
