![](https://github.com/r2am9d/vendibase/blob/master/assets/images/vendibase.png)

<p align="center">
  <h2 align="center">Vendibase</h2>

  <p align="center">
    Inventory app manager that uses <a href="https://github.com/simolus3/drift">Drift</a>
    <br>Application made with <a href="https://github.com/flutter/flutter">Flutter</a> :heart:<br><br>
    <a href='https://ko-fi.com/A0A0C9HCQ' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
  </p>
</p>

## Table of contents

- [Description](#description)
- [Quick start](#quick-start)
- [What's included](#whats-included)
- [Application Structure](#application-structure)
- [Bugs and feature requests](#bugs-and-feature-requests)
- [Contributing](#contributing)
- [Creator](#creator)
- [Copyright and license](#copyright-and-license)

## Description

**Vendibase** is a simple android inventory app. manager catered towards small/mini business owners e.g. Sari-sari stores and the likes. Was coined using **"Vendor"** & **"Database"**.

## Quick start

Follow the instructions in the [official documentation](https://flutter.io/docs/get-started/install) to get up and running.

## What's included

* CRUD: create, read, update and delete data with Drift 
    - Categories, Units, Persons, Earnings, Products, Arrears
* A dedicated dashboard for data visualization & overview
* Search function, to look for Products, Arrears
* Database backup & restore
* Arrear due local notification
* Database encryption
* Internationalization
* Responsive layout
* Following Flutter's [best practices](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)!

### Drift

This application is using Drift to handle CRUD operations enabling offline data persistence.

### Libraries & Tools Used

* [Drift](https://github.com/simolus3/drift) (Persistence Library)
* [Provider](https://github.com/rrousselGit/provider) (State Management)
* [Permissions](https://github.com/baseflow/flutter-permission-handler)
* [Shared Preferences](https://github.com/flutter/plugins/tree/main/packages/shared_preferences/shared_preferences)
* [Forms](https://github.com/danvick/flutter_form_builder)
* [App Notifications](https://github.com/MaikuB/flutter_local_notifications)
* [Data Visualization](https://github.com/syncfusion/flutter-widgets)
* [Streams](https://github.com/ReactiveX/rxdart)
* [Animations](https://github.com/flutter/packages/tree/master/packages/animations)

### UI/UX

* [Salomon Bottom Bar](https://github.com/lukepighetti/salomon_bottom_bar)
* [Auto Size Text](https://github.com/leisim/auto_size_text)
* [Native Splash](https://github.com/jonbhanson/flutter_native_splash)
* [Expandable](https://github.com/aryzhov/flutter-expandable)
* [Font Awesome](https://github.com/fluttercommunity/font_awesome_flutter)
* [Tooltip](https://pub.dev/packages/just_the_tooltip)
* [Launcher Icons](https://github.com/Davenchy/flutter_launcher_icons/tree/fixMinSdkParseFlutter2.8)
* [Toggle](https://github.com/SplashByte/animated_toggle_switch)
* [Easy Image Viewer](https://github.com/thesmythgroup/easy_image_viewer)
* [Transitions](https://github.com/kalismeras61/flutter_page_transition)
* [Onboarding](https://github.com/Pyozer/introduction_screen)

### Forked & Enhanced repo

* [Gallery Saver](https://github.com/r2am9d/gallery_saver)
* [Editable](https://github.com/r2am9d/editable)

### Up-Coming Features

* Enhanced Form Validations
* Improved Error Handling
* Google Play Store Availability

## Application Structure

Keeping it simple with a bit of experience in web application development :)

```dart
lib/
|- database/
|- page/
|- provider/
|- router/
|- theme/
|- utils/
|- home.dart
|- main.dart
```

## Bugs and feature requests

Have a bug or a feature request? Please first read the [issue guidelines](https://github.com/r2am9d/vendibase/blob/master/CONTRIBUTING.md) and search for existing and closed issues. If your problem or idea is not addressed yet, [please open a new issue](https://github.com/r2am9d/vendibase/issues/new).

## Contributing

Please read through our [contributing guidelines](https://github.com/r2am9d/vendibase/blob/master/CONTRIBUTING.md). Included are directions for opening issues, coding standards, and notes on development.

Lastly, all HTML and CSS should conform to the [Code Guide](https://github.com/mdo/code-guide).

## Creator

**Ram Delatina**

- <https://github.com/r2am9d>

## Copyright and license

Code and documentation copyright 2022 the authors. Code released under the [BSD 3-Clause License](https://github.com/r2am9d/vendibase/blob/master/LICENSE.md).
