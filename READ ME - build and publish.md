# Touch Wood — native iOS app

A complete SwiftUI app. Tap the wooden surface and it gives a real haptic knock
(CoreHaptics), plays a wooden knock sound, shows a ripple where you touched, and
displays a short reassurance ("Safe.", "Warded off.", and so on). It keeps a
running count of your knocks and a daily streak, and has a settings screen for
the sound and haptics, sharing, and resetting your count. Portrait, full screen,
works offline. Nothing is collected and nothing leaves the device.

## What is in this folder
- `TouchWood.xcodeproj` — open this in Xcode.
- `TouchWood/` — the source:
  - `TouchWoodApp.swift` — app entry point.
  - `ContentView.swift` — the wood surface, tap handling, ripple, message.
  - `Haptics.swift` — the CoreHaptics "knock" (falls back to a basic buzz on
    older devices).
  - `SoundPlayer.swift` — plays the knock sound.
  - `Stats.swift` — the knock count and daily streak, stored on the device.
  - `SettingsView.swift` — the settings screen (sound, haptics, share, reset).
  - `Assets.xcassets` — the wood background image and the app icon.
  - `Resources/knock.wav` — the knock sound.
- `project.yml` — the project definition (only needed if you regenerate the
  project with XcodeGen; you can ignore it).

The app icon and everything else is already set up. The bundle identifier is
`com.stefanocheng.touchwood` — change it in Xcode if you want a different one.

---

## The parts only you can do
Three things are tied to your Apple ID, your card and your identity, so you have
to do them yourself:
1. Install Xcode.
2. Pay for the Apple Developer Program (US$99 / year).
3. Press submit on the App Store.

Everything below walks through each step.

## Step 1 — Install Xcode (free)
Open the App Store app on this Mac, search "Xcode", install it. It is large
(15 GB or so) and takes a while. When it finishes, open it once and let it
install the extra components it asks for.

## Step 2 — Open and run the app on your own phone (free, no Developer Program yet)
1. Double-click `TouchWood.xcodeproj`.
2. In Xcode go to Settings (Cmd-,) > Accounts > add your Apple ID.
3. Click the `TouchWood` project in the sidebar, select the `TouchWood` target,
   open "Signing & Capabilities". Tick "Automatically manage signing" and choose
   your name under Team.
4. Plug in your iPhone, pick it as the run destination at the top, press the Run
   button (the triangle). The app installs on your phone.
   - With a free account the app works for 7 days, then you re-run it from Xcode
     to renew. The paid program (below) removes that limit and lets you publish.

This is the fastest way to feel the haptic knock on a real device before paying
for anything.

## Step 3 — Join the Apple Developer Program (US$99 / year) — this is the pay step
Go to developer.apple.com/programs and enrol with your Apple ID. You pay the
US$99, and Apple sometimes asks to verify your identity, so activation can take
a day or two. You need this to put the app on the App Store.

## Step 4 — Create the app record
At appstoreconnect.apple.com, sign in with the same Apple ID, go to Apps, add a
new app:
- Platform: iOS.
- Name: the public App Store name (for example "Touch Wood" — it must be unique
  across the whole App Store, so you may need a small variation).
- Bundle ID: `com.stefanocheng.touchwood` (must match the app).
- SKU: any private code, for example `touchwood01`.

## Step 5 — Upload the build from Xcode
1. In Xcode, set the run destination to "Any iOS Device (arm64)".
2. Product > Archive. When the Organizer opens, choose "Distribute App" >
   "App Store Connect" > "Upload".
3. Wait a few minutes for the build to appear in App Store Connect.

## Step 6 — Fill in the store listing and submit
In App Store Connect, on the app's page, you need to provide:
- Screenshots (at least the 6.7-inch iPhone size; take them on your phone or in
  the Simulator).
- Description, keywords, and a support URL.
- A privacy policy URL. This is required even though the app collects nothing; a
  one-page "this app collects no data" policy is enough. Under App Privacy,
  declare "Data Not Collected".
- Category (Lifestyle or Entertainment fits) and an age rating (answer the
  questionnaire; all "no" gives 4+).
Then select the uploaded build and press "Submit for Review". Review usually
takes a day or two.

---

## One honest warning about App Review
A very simple novelty app can be rejected under Apple's guidelines on minimum
functionality and "spam" (guidelines 4.2 and 4.3). To reduce that risk the app
now has a running knock count, a daily streak, a settings screen (sound and
haptics toggles, reset) and a share button.

That is a reasonable case, but it is not a guarantee. If review does push back
on 4.2, the next thing to add is a Home Screen widget showing the streak, or a
Shortcuts action. Both need a second target and an App Group, so they are worth
doing only if you actually need them.

## If you change the bundle identifier or add files
Either do it directly in Xcode, or edit `project.yml` and regenerate with
`xcodegen generate` (XcodeGen is already installed on this Mac). Both work; doing
it in Xcode is simpler.
