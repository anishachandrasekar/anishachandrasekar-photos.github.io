/* ==========================================================================
   YOUR PHOTOS
   --------------------------------------------------------------------------
   This is the only file you need to edit to add, remove or reorder photos.

   EASIEST WAY (Mac): run ./add-photos.sh with your photos. It resizes them,
   converts iPhone .HEIC files to .jpg, removes GPS location, copies them into
   /images and adds them to this list for you. See README.md.

   BY HAND:
     1. Copy your photo into the /images folder (JPG, PNG or WebP).
        Keep it around 2000px on the long side so the site loads quickly.
     2. Add a line to the list below, like:
          { src: "images/harbour.jpg", title: "Harbour at dawn", place: "Lisbon, Portugal", year: "2025" },
     3. Save, then refresh the page.

   FIELDS
     src       required. Path to the image file.
     title     optional. If set, it's shown when someone opens the photo.
               If not, the place is shown instead.
     place     filled in by add-photos.sh from the photo's location, as
               "City, Country". Change it to anything, or delete it to hide it.
     year      filled in by add-photos.sh from the date the photo was taken.
     caption   optional. An extra line of text under the title/place.
     category  optional. If any photo has one, filter buttons appear above
               the gallery. Leave it out everywhere to hide the filters.
     size      filled in by add-photos.sh (width x height). It helps keep the
               columns even. Fine to leave out if you add a photo by hand.

   The order of this list is the order on the page. Remember the comma
   at the end of each line.
   ========================================================================== */

const PHOTOS = [
  { src: "images/img-1303.jpg", size: "1500x2000", title: "", place: "Vancouver, Canada", year: "2026" },
  { src: "images/img-1452.jpg", size: "1500x2000", title: "", place: "London, United Kingdom", year: "2025" },
  { src: "images/img-1534.jpg", size: "2000x1125", title: "Committee in session", place: "Galle, Sri Lanka", year: "2026" },
  { src: "images/img-1803.jpg", size: "1500x2000", title: "", place: "Galle, Sri Lanka", year: "2026" },
  { src: "images/img-2157.jpg", size: "1500x2000", title: "", place: "Southern Province, Sri Lanka", year: "2026" },
  { src: "images/img-2275.jpg", size: "2000x1125", title: "", place: "Southern Province, Sri Lanka", year: "2026" },
  { src: "images/img-2450.jpg", size: "1500x2000", title: "", place: "London, United Kingdom", year: "2025" },
  { src: "images/img-2986.jpg", size: "2000x1500", title: "", place: "Ambleside, United Kingdom", year: "2025" },
  { src: "images/img-3200.jpg", size: "1500x2000", title: "", place: "Genting Highlands, Malaysia", year: "2026" },
  { src: "images/img-3286.jpg", size: "2000x1500", title: "", place: "Ambleside, United Kingdom", year: "2025" },
  { src: "images/img-3779.jpg", size: "1500x2000", title: "", place: "London, United Kingdom", year: "2025" },
  { src: "images/img-4396.jpg", size: "1500x2000", title: "", place: "Singapore", year: "2026" },
  { src: "images/img-4693.jpg", size: "1500x2000", title: "", place: "New York, United States", year: "2025" },
  { src: "images/img-5424.jpg", size: "1500x2000", title: "", place: "Washington, United States", year: "2025" },
  { src: "images/img-7185.jpg", size: "1500x2000", title: "", place: "Cape Town, South Africa", year: "2026" },
  { src: "images/img-7238.jpg", size: "1500x2000", title: "", place: "Cape Town, South Africa", year: "2026" },
  { src: "images/img-7427.jpg", size: "1500x2000", title: "", place: "Cape Town, South Africa", year: "2026" },
  { src: "images/img-7456.jpg", size: "1500x2000", title: "Us", place: "Cape Town, South Africa", year: "2026" },
  { src: "images/img-7558.jpg", size: "1500x2000", title: "", place: "Muizenberg, South Africa", year: "2026" },
  { src: "images/img-7919.jpg", size: "1500x2000", title: "", place: "Cape Point, South Africa", year: "2026" },
  { src: "images/img-8773.jpg", size: "1500x2000", title: "", place: "Eastbourne, United Kingdom", year: "2024" },
  { src: "images/img-8850.jpg", size: "1500x2000", title: "", place: "St. Moritz, Switzerland", year: "2023" },
  { src: "images/img-9132.jpg", size: "1500x2000", title: "", place: "Bath, United Kingdom", year: "2025" },
  { src: "images/img-9209.jpg", size: "1500x2000", title: "", place: "Bath, United Kingdom", year: "2025" },
  { src: "images/img-9641.jpg", size: "1500x2000", title: "", place: "New York, United States", year: "2026" },
  { src: "images/img-9737.jpg", size: "1500x2000", title: "", place: "New York, United States", year: "2026" },
  { src: "images/img-9869.jpg", size: "2000x1500", title: "", place: "New York, United States", year: "2026" },
  // add-photos.sh adds new photos just above this line — please leave it here.
];
