-- ================================================================
-- VILLAGE DIGITAL LIBRARY — COMPLETE FRESH SETUP
-- ================================================================
-- HOW TO RUN:
-- 1. Go to supabase.com → your project
-- 2. Click "SQL Editor" on left sidebar
-- 3. Click "New query" button
-- 4. Copy EVERYTHING below and paste it
-- 5. Click the green "RUN" button
-- ================================================================

-- ----------------------------------------------------------------
-- PART A: DELETE OLD BROKEN TABLES (start 100% fresh)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS admin_logs        CASCADE;
DROP TABLE IF EXISTS announcements     CASCADE;
DROP TABLE IF EXISTS notifications     CASCADE;
DROP TABLE IF EXISTS download_history  CASCADE;
DROP TABLE IF EXISTS reading_history   CASCADE;
DROP TABLE IF EXISTS wishlists         CASCADE;
DROP TABLE IF EXISTS comments          CASCADE;
DROP TABLE IF EXISTS ratings           CASCADE;
DROP TABLE IF EXISTS books             CASCADE;
DROP TABLE IF EXISTS categories        CASCADE;
DROP TABLE IF EXISTS profiles          CASCADE;

-- ----------------------------------------------------------------
-- PART B: CREATE ALL TABLES
-- ----------------------------------------------------------------

-- 1. PROFILES (stores every user's info)
CREATE TABLE profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name          TEXT,
  email         TEXT,
  age           INTEGER,
  gender        TEXT,
  photo_url     TEXT,
  is_admin      BOOLEAN DEFAULT FALSE,
  is_blocked    BOOLEAN DEFAULT FALSE,
  streak        INTEGER DEFAULT 0,
  books_read    INTEGER DEFAULT 0,
  ratings_given INTEGER DEFAULT 0,
  last_login    TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 2. CATEGORIES (Comics, Stories, Science, etc.)
CREATE TABLE categories (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT NOT NULL,
  icon       TEXT DEFAULT '📖',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. BOOKS
CREATE TABLE books (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT NOT NULL,
  author      TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  description TEXT,
  cover_url   TEXT,
  pdf_url     TEXT NOT NULL,
  is_featured BOOLEAN DEFAULT FALSE,
  is_trending BOOLEAN DEFAULT FALSE,
  reads       INTEGER DEFAULT 0,
  avg_rating  FLOAT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 4. RATINGS (1 to 5 stars per book per user)
CREATE TABLE ratings (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id    UUID REFERENCES books(id) ON DELETE CASCADE,
  user_id    UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating     INTEGER CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_id)
);

-- 5. COMMENTS (with reply support via parent_id)
CREATE TABLE comments (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id    UUID REFERENCES books(id) ON DELETE CASCADE,
  user_id    UUID REFERENCES profiles(id) ON DELETE CASCADE,
  parent_id  UUID REFERENCES comments(id) ON DELETE CASCADE,
  content    TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. WISHLISTS
CREATE TABLE wishlists (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id    UUID REFERENCES books(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 7. READING HISTORY
CREATE TABLE reading_history (
  id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  read_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 8. DOWNLOAD HISTORY
CREATE TABLE download_history (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id       UUID REFERENCES books(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 9. NOTIFICATIONS
CREATE TABLE notifications (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title      TEXT NOT NULL,
  body       TEXT,
  is_read    BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. ANNOUNCEMENTS
CREATE TABLE announcements (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title      TEXT NOT NULL,
  body       TEXT,
  sent_by    UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. ADMIN LOGS
CREATE TABLE admin_logs (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID REFERENCES profiles(id),
  action     TEXT NOT NULL,
  details    TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- PART C: ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- ----------------------------------------------------------------
ALTER TABLE profiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE books           ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories      ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings         ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlists       ENABLE ROW LEVEL SECURITY;
ALTER TABLE reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE download_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications   ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements   ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_logs      ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------
-- PART D: SECURITY POLICIES
-- ----------------------------------------------------------------

-- PROFILES: anyone can read, only own user can insert/update
CREATE POLICY "p_sel"  ON profiles FOR SELECT USING (true);
CREATE POLICY "p_ins"  ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "p_upd"  ON profiles FOR UPDATE USING (auth.uid() = id);

-- BOOKS: anyone can read, only admin can add/edit/delete
CREATE POLICY "b_sel"  ON books FOR SELECT USING (true);
CREATE POLICY "b_ins"  ON books FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "b_upd"  ON books FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "b_del"  ON books FOR DELETE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- CATEGORIES: anyone can read, only admin can modify
CREATE POLICY "c_sel"  ON categories FOR SELECT USING (true);
CREATE POLICY "c_ins"  ON categories FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "c_upd"  ON categories FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "c_del"  ON categories FOR DELETE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- RATINGS
CREATE POLICY "r_sel"  ON ratings FOR SELECT USING (true);
CREATE POLICY "r_ins"  ON ratings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "r_upd"  ON ratings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "r_del"  ON ratings FOR DELETE USING (auth.uid() = user_id);

-- COMMENTS: anyone reads, own user inserts, own user or admin deletes
CREATE POLICY "cm_sel" ON comments FOR SELECT USING (true);
CREATE POLICY "cm_ins" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "cm_del" ON comments FOR DELETE USING (
  auth.uid() = user_id OR
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- WISHLISTS
CREATE POLICY "w_all"  ON wishlists         FOR ALL USING (auth.uid() = user_id);

-- READING HISTORY
CREATE POLICY "rh_all" ON reading_history   FOR ALL USING (auth.uid() = user_id);

-- DOWNLOAD HISTORY
CREATE POLICY "dh_all" ON download_history  FOR ALL USING (auth.uid() = user_id);

-- NOTIFICATIONS: users see own, anyone can insert (for admin broadcast)
CREATE POLICY "n_sel"  ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "n_ins"  ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "n_upd"  ON notifications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "n_del"  ON notifications FOR DELETE USING (auth.uid() = user_id);

-- ANNOUNCEMENTS
CREATE POLICY "an_sel" ON announcements FOR SELECT USING (true);
CREATE POLICY "an_ins" ON announcements FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- ADMIN LOGS
CREATE POLICY "al_ins" ON admin_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "al_sel" ON admin_logs FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- ----------------------------------------------------------------
-- PART E: DEFAULT CATEGORIES
-- ----------------------------------------------------------------
INSERT INTO categories (name, icon) VALUES
  ('Comics',    '🦸'),
  ('Stories',   '📖'),
  ('Science',   '🔬'),
  ('History',   '🏛️'),
  ('Poetry',    '🎭'),
  ('Religion',  '🕌'),
  ('Education', '📚'),
  ('Children',  '👦'),
  ('Adventure', '🗺️'),
  ('Romance',   '💕');

-- ----------------------------------------------------------------
-- PART F: VERIFY EVERYTHING WORKED
-- ----------------------------------------------------------------
SELECT 'TABLES CREATED:' AS status;
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT 'CATEGORIES ADDED:' AS status;
SELECT icon, name FROM categories ORDER BY name;

-- ================================================================
-- ✅ If you see 11 tables and 10 categories listed above,
--    the database setup is 100% complete!
--
-- NEXT STEP: Run FIX_ADMIN_PROFILE.sql to create your admin account
-- ================================================================
