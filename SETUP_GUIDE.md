# 📱 VILLAGE DIGITAL LIBRARY - COMPLETE SETUP GUIDE
## Zero Cost | Mobile Friendly | Step by Step

---

## STEP 1: CREATE SUPABASE ACCOUNT (5 minutes)

1. Open phone browser → go to: **https://supabase.com**
2. Click **"Start your project"**
3. Sign up with **Google** (easiest)
4. Click **"New Project"**
5. Fill:
   - Project name: `village-library`
   - Password: (choose a strong password, SAVE IT!)
   - Region: Choose nearest to you
6. Click **"Create new project"**
7. Wait 2 minutes for setup to complete

---

## STEP 2: SET UP DATABASE (3 minutes)

1. In Supabase dashboard, click **"SQL Editor"** (left sidebar)
2. Click **"New query"**
3. Open the file `SETUP_DATABASE.sql` from this folder
4. Copy ALL the text from that file
5. Paste it into the SQL Editor
6. Click **"Run"** (green button)
7. You should see: "Success. No rows returned"

---

## STEP 3: GET YOUR API KEYS (2 minutes)

1. In Supabase dashboard, click ⚙️ **"Settings"** (left sidebar)
2. Click **"API"**
3. Copy **"Project URL"** — looks like: `https://abcdefg.supabase.co`
4. Copy **"anon public"** key — long string starting with `eyJ...`
5. Save both somewhere safe

---

## STEP 4: CONFIGURE THE APP (2 minutes)

1. Open `index.html` in a text editor
2. Find these 3 lines near the top of the `<script>` section:
   ```
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   const SUPER_ADMIN_EMAIL = 'YOUR_SUPER_ADMIN_EMAIL';
   ```
3. Replace:
   - `YOUR_SUPABASE_URL` → paste your Project URL
   - `YOUR_SUPABASE_ANON_KEY` → paste your anon key
   - `YOUR_SUPER_ADMIN_EMAIL` → your email (this gives you super admin)
4. Save the file

---

## STEP 5: DEPLOY ON VERCEL (5 minutes)

### Option A: Drag & Drop (Easiest!)
1. Go to: **https://vercel.com**
2. Sign up with GitHub
3. Click **"Add New Project"**
4. Click **"Deploy from template"** or drag & drop your folder
5. Your app gets a FREE URL like: `your-app.vercel.app`

### Option B: GitHub (More control)
1. Create GitHub account: **https://github.com**
2. Create new repository named `village-library`
3. Upload all files (index.html, sw.js, manifest.json)
4. Go to Vercel → Import GitHub repo
5. Deploy → Done!

---

## STEP 6: ADD APP ICONS (optional but recommended)

For the PWA install to work nicely:
1. Create two square images (192x192 and 512x512 pixels)
2. Name them: `icon-192.png` and `icon-512.png`
3. Upload them alongside index.html
4. You can use any free icon maker app on your phone

---

## HOW TO USE THE APP

### As Admin:
1. Sign up with the email you set as SUPER_ADMIN_EMAIL
2. You'll see **Admin Panel** in your Profile page
3. Add categories first (Comics, Stories, etc.)
4. Then add books with PDF links

### Adding PDFs for Free:
- Upload PDF to **Google Drive**
- Right click → Share → Anyone with link can view
- Copy the link and paste in the app
- The app uses Google Docs Viewer to show PDFs

### For other admins:
- Go to Admin Panel → Add Admin
- Enter their email after they create an account

---

## FEATURES INCLUDED ✅

- ✅ Login / Signup / Forgot Password
- ✅ User Profiles with photo, age, gender
- ✅ Reading streak counter
- ✅ Book categories with icons
- ✅ Search books (text + voice)
- ✅ Featured & Trending sections
- ✅ AI-powered book recommendations
- ✅ Online PDF reader (Google Docs viewer)
- ✅ Book download option
- ✅ Wishlist / Save books
- ✅ Reading history
- ✅ Download history
- ✅ Rate books (1-5 stars)
- ✅ Comments & Replies
- ✅ Notifications system
- ✅ Admin panel
- ✅ Add/Edit/Delete books
- ✅ Add/Delete categories
- ✅ Block/Unblock users
- ✅ Add other admins
- ✅ Send announcements to all users
- ✅ Analytics (most read books)
- ✅ Enable/Disable downloads
- ✅ Export library data
- ✅ Admin activity logs
- ✅ Dark & Light mode
- ✅ PWA installable (Add to home screen)
- ✅ Offline caching (Service Worker)
- ✅ Change password anytime
- ✅ Mobile-first design
- ✅ Glassmorphism UI

---

## NEED HELP?

Common issues:
- **"Invalid API key"** → Double-check your Supabase keys in index.html
- **Books not loading** → Run the SQL script again
- **Can't add books** → Make sure you signed up with your admin email
- **PDF not opening** → Make sure the Google Drive link is set to "Anyone can view"

---

Total Cost: ₹0 / $0 / FREE FOREVER 🎉
