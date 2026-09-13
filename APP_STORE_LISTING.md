# App Store listing copy — Touch the Wood

Everything App Store Connect asks you for, ready to paste. Character limits are
Apple's; the counts in brackets are what the text below actually uses.

---

## App Name  (limit 30)
```
Touch the Wood
```
[14]

Confirmed and reserved in App Store Connect. "Touch Wood" was already taken,
which is why this name has "the" in it. The Home Screen name stays the shorter
"Touch Wood", which Apple permits as long as the two are recognisably similar.

## Subtitle  (limit 30)
```
Knock on wood, anywhere
```
[23]

## Promotional text  (limit 170, editable any time without a new build)
```
Tap the wood and feel a real knock. Keep a running count, build a daily streak, and never tempt fate again. No account, no data collected, works completely offline.
```
[164]

## Keywords  (limit 100, comma separated, no spaces after commas)
```
knock on wood,superstition,luck,good luck,haptic,fidget,streak,ritual,lucky,jinx,wood
```
[85]

Do not repeat words already in the app name; Apple indexes those separately.

## Description  (limit 4000)
```
Some things you don't say out loud without knocking on wood.

Touch the Wood puts a piece of wood in your pocket. Tap the screen and you get a real knock: a sharp rap you feel through the phone, a wooden sound, a ripple spreading from your fingertip, and a word of reassurance.

A REAL KNOCK, NOT A BUZZ
The haptics are built with Core Haptics as a two-part tap, a sharp strike followed by a faint second tick. It feels like wood rather than a generic vibration. On devices without a Taptic Engine the app falls back to a standard impact, so it still works.

KEEP COUNT
Every knock is counted. Knock at least once a day and your streak grows. Miss a day and it starts again from one. Over time it becomes a quiet record of every moment you would rather not tempt fate.

NOTHING LEAVES YOUR PHONE
No account. No sign-up. No network. Your count, your streak and your settings live on your device and nowhere else. Touch the Wood collects nothing, sends nothing, and works perfectly with no connection at all. Put the phone in Airplane Mode and nothing changes.

SIMPLE CONTROLS
Turn the sound off when you need to be quiet. Turn the haptics off when you want to save battery. Reset your count whenever you want a fresh start. Share your tally if the mood takes you.

Fourteen different reassurances, shown at random and never twice in a row.

Knock on wood. It costs nothing, and you can never be entirely sure it isn't helping.
```

## What's New  (first release)
```
First release.
```

---

## Form answers

| Field | Answer |
|---|---|
| Primary category | Lifestyle |
| Secondary category | Entertainment |
| Age rating | 4+ (answer "None" to every content question) |
| Price | Free |
| Bundle ID | com.stefanocheng.touchwood |
| SKU | touchwood01 |
| Copyright | 2026 Stefano Cheng |
| Contains ads | No |
| In-app purchases | No |
| Sign in required | No |
| Export compliance | Already answered in the build. `ITSAppUsesNonExemptEncryption` is set to false in Info.plist, so App Store Connect should stop asking. |

## App Privacy section
Choose **Data Not Collected**. Do not tick anything else. This is accurate: the
app has no analytics, no third-party SDKs and makes no network requests.

## URLs you must supply
- **Privacy policy URL** — required. Host `privacy-policy.html` from this folder
  and paste the resulting address. See the hosting note below.
- **Support URL** — required. It can be the same page, or any page with a way to
  contact you.
- **Marketing URL** — optional, leave blank.

## Screenshots
At least one set for the largest iPhone display size App Store Connect lists;
it states the exact pixel dimensions next to the upload box. The simplest way to
get correctly sized images is to run the app in the Simulator on the largest
iPhone model available and capture from there:

```
xcrun simctl boot "iPhone 17 Pro Max"
xcrun simctl io booted screenshot ~/Desktop/shot1.png
```

Worth capturing: the wood with a count and streak showing, a knock in progress
with the ripple and a reassurance message, and the settings screen.

Note that a fresh install shows "0 knocks" and no streak, which makes a weak
first screenshot. Tap a few times, and on a real device come back on a second
day, so the streak line appears.

---

## Hosting the privacy policy

Apple needs a publicly reachable URL. A Claude artifact link or a private file
will not do; App Review has to be able to open it, and Apple re-checks it later.
The cheapest durable option is GitHub Pages:

1. Push this repository to a public GitHub repo.
2. Settings > Pages > Build from branch, pick your branch, folder `/ (root)`.
3. The page appears at `https://<username>.github.io/<repo>/privacy-policy.html`.

Published at https://stefanocheng.github.io/touch-the-wood/privacy-policy.html
The contact line points at the repo's GitHub issues page, so no email address is
exposed. Use the same URL for the Support URL field.
