# Photography portfolio

A simple static website: plain HTML, CSS and a little JavaScript. No frameworks,
no build step, nothing to install. Upload this folder and it works.

```
portfolio-site/
├── index.html              ← home page: your name, intro line, the gallery
├── about.html              ← About page text and photo
├── photos.js               ← your list of photos (the file you'll edit most)
├── css/style.css           ← colours, fonts, spacing, number of columns (top of file)
├── js/gallery.js           ← builds the gallery and the full-screen viewer (no need to edit)
├── images/                 ← your photos go here
├── add-photos.sh           ← Mac helper: resize, convert, remove metadata, add to photos.js
├── tools/strip_metadata.py ← removes hidden data from photos (used by add-photos.sh)
└── tools/photo_info.swift  ← reads the year and city/country first (used by add-photos.sh)
```

## See it on your computer

Double-click `index.html`. It opens in your browser.

## Add your photos

**Easiest (Mac).** Open Terminal in this folder (right-click the folder in
Finder → *New Terminal at Folder*) and run:

```bash
./add-photos.sh ~/Desktop/my-photo.HEIC ~/Desktop/another.jpg
```

or give it a whole folder:

```bash
./add-photos.sh ~/Desktop/new-photos
```

It converts iPhone `.HEIC` files to `.jpg`, shrinks them to 2000px so the site
stays fast, turns them the right way up, notes the **year and city/country** the
photo was taken in (shown when someone opens it), **removes all hidden metadata**, copies
them into `images/` and adds them to `photos.js`. Your originals are not changed.
Then open `photos.js` to add titles (shown instead of the place), fix any place
names, and reorder them.

**Edited, filtered or cropped a photo?** Export the new version with the **same
file name** (e.g. `IMG_7185.jpg`) and run `add-photos.sh` on it again. The photo on
the site is replaced, and its title, caption and position stay as they were. To
remove a photo, delete its line in `photos.js` and its file in `images/`.

**By hand.** Copy a `.jpg` into `images/`, add a line to `photos.js`, then run
`python3 tools/strip_metadata.py` to clean it (see *Privacy* below).

**Link preview image.** The `og:image` line in `index.html` picks the photo shown
when you paste your link into a chat. Change it to your favourite.

## Privacy: what's removed from your photos

Phone and camera photos carry hidden data (EXIF/XMP) that anyone who downloads
them can read: **GPS location**, the exact date and time, the phone or camera model and
serial number, software version and editing history. iPhone JPEGs can also hide a
second image with its own metadata. `add-photos.sh` removes all of this and keeps
only the picture and its colour profile. It checks each photo afterwards and
won't add one it couldn't clean.

If you ever put photos into `images/` another way, check them all with:

```bash
python3 tools/strip_metadata.py
```

It reports each file as *cleaned*, *already clean* or *PROBLEM*, and it's safe to
run any time. It's a good habit before every upload.

**Place names.** Before cleaning, the script turns each photo's GPS position into
just "City, Country" using macOS's built-in map lookup (the same one the Photos app
uses). Only that text appears on the site, never the exact position. Photos taken
near home will show your city: change or delete the `place` in `photos.js` for
any you'd rather keep vague.

Things to know that no tool can fix:

- **What's in the picture.** House numbers, street signs, car plates, school
  uniforms or a view from your window can reveal where you are. Look before you post.
- **Downloads can't be prevented.** Anything shown on a website can be saved or
  screenshotted. "Disable right-click" tricks don't stop this, so this site doesn't
  use them. Keep photos at 2000px (the default) so full-resolution originals stay
  with you.
- **Only upload this folder.** Your original HEIC files are in the folder above it.
  Upload `portfolio-site` only, never the folder that contains it.

## Customise

| To change… | Edit… |
|---|---|
| Name, tab title, intro line | `index.html` (look for the `====` comment blocks) |
| About text and photo | `about.html` |
| Colours, font, gap between photos, number of columns | the `:root` block at the top of `css/style.css` |
| Dark background | uncomment the second `:root` block in `css/style.css` |
| Photos, titles, captions, order, categories | `photos.js` |

Categories are optional. If no photo has a `category`, the filter buttons disappear.

## Publish it (free)

- **Netlify Drop** (easiest): go to app.netlify.com/drop and drag the
  `portfolio-site` folder onto the page. You get a link straight away.
- **GitHub Pages**: create a repository, upload the contents of this folder, then
  turn on *Settings → Pages → Deploy from branch*.
- **Vercel / Cloudflare Pages**: import the folder as a static site with no build command.

To update the site later, add photos the same way and upload the folder again.
