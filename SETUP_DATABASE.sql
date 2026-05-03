-- =====================================================
-- VILLAGE DIGITAL LIBRARY - SUPABASE DATABASE SETUP
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)
-- =====================================================

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  email TEXT,
  age INTEGER,
  gender TEXT,
  photo_url TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  is_blocked BOOLEAN DEFAULT FALSE,
  streak INTEGER DEFAULT 0,
  books_read INTEGER DEFAULT 0,
  ratings_given INTEGER DEFAULT 0,
  last_login TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  icon TEXT DEFAULT '📖',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. BOOKS TABLE
CREATE TABLE IF NOT EXISTS books (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  description TEXT,
  cover_url TEXT,
  pdf_url TEXT NOT NULL,
  is_featured BOOLEAN DEFAULT FALSE,
  is_trending BOOLEAN DEFAULT FALSE,
  reads INTEGER DEFAULT 0,
  avg_rating FLOAT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. RATINGS TABLE
CREATE TABLE IF NOT EXISTS ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_id)
);

-- 5. COMMENTS TABLE
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. WISHLISTS TABLE
CREATE TABLE IF NOT EXISTS wishlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 7. READING HISTORY TABLE
CREATE TABLE IF NOT EXISTS reading_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  read_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 8. DOWNLOAD HISTORY TABLE
CREATE TABLE IF NOT EXISTS download_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, book_id)
);

-- 9. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. ANNOUNCEMENTS TABLE
CREATE TABLE IF NOT EXISTS announcements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  body TEXT,
  sent_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. ADMIN LOGS TABLE
CREATE TABLE IF NOT EXISTS admin_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  details TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE download_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_logs ENABLE ROW LEVEL SECURITY;

-- PROFILES: users can read all, update own
CREATE POLICY "profiles_read_all" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- BOOKS: everyone can read
CREATE POLICY "books_read_all" ON books FOR SELECT USING (true);
CREATE POLICY "books_insert_admin" ON books FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "books_update_admin" ON books FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);
CREATE POLICY "books_delete_admin" ON books FOR DELETE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- CATEGORIES: everyone can read, only admin can modify
CREATE POLICY "categories_read_all" ON categories FOR SELECT USING (true);
CREATE POLICY "categories_admin" ON categories FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- RATINGS: own ratings
CREATE POLICY "ratings_all" ON ratings FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "ratings_read" ON ratings FOR SELECT USING (true);

-- COMMENTS: read all, insert/delete own (admin can delete all)
CREATE POLICY "comments_read" ON comments FOR SELECT USING (true);
CREATE POLICY "comments_insert" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "comments_delete_own" ON comments FOR DELETE USING (
  auth.uid() = user_id OR
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- WISHLISTS: own data
CREATE POLICY "wishlists_own" ON wishlists FOR ALL USING (auth.uid() = user_id);

-- READING HISTORY: own data
CREATE POLICY "reading_history_own" ON reading_history FOR ALL USING (auth.uid() = user_id);

-- DOWNLOAD HISTORY: own data
CREATE POLICY "download_history_own" ON download_history FOR ALL USING (auth.uid() = user_id);

-- NOTIFICATIONS: own data
CREATE POLICY "notifications_own" ON notifications FOR ALL USING (auth.uid() = user_id);

-- ANNOUNCEMENTS: read all, insert admin
CREATE POLICY "announcements_read" ON announcements FOR SELECT USING (true);
CREATE POLICY "announcements_admin" ON announcements FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- ADMIN LOGS: admin only
CREATE POLICY "admin_logs_admin" ON admin_logs FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
);

-- =====================================================
-- SAMPLE DATA (Optional - delete if not needed)
-- =====================================================

INSERT INTO categories (name, icon) VALUES
  ('Comics', '🦸'),
  ('Stories', '📖'),
  ('Science', '🔬'),
  ('History', '🏛️'),
  ('Poetry', '🎭'),
  ('Religion', '🕌'),
  ('Education', '📚'),
  ('Children', '👦')
ON CONFLICT DO NOTHING;

-- =====================================================
-- DONE! Your database is ready.
-- =====================================================
