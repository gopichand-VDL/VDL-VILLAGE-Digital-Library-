-- ================================================================
-- STEP 2: CREATE YOUR ADMIN PROFILE
-- ================================================================
-- Run this AFTER running STEP1_FRESH_DATABASE.sql
--
-- BEFORE RUNNING THIS FILE you must:
-- 1. Go to Supabase → Authentication → Users
-- 2. Find ravalurugopichand@gmail.com in the list
-- 3. Click on it
-- 4. Copy the "User UID" — looks like:
--    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-- 5. Replace PASTE_YOUR_UUID_HERE below with that UUID
-- 6. Then run this file
-- ================================================================

-- Replace PASTE_YOUR_UUID_HERE with your real UUID from Supabase Auth
INSERT INTO profiles (
  id,
  name,
  email,
  is_admin,
  is_blocked,
  streak,
  books_read,
  ratings_given,
  created_at
)
VALUES (
  '507f6c90-d65b-457b-b48b-acc8ed962786',
  'Gopichand',
  'ravalurugopichand@gmail.com',
  TRUE,
  FALSE,
  0,
  0,
  0,
  NOW()
);

-- ----------------------------------------------------------------
-- VERIFY: You should see 1 row with is_admin = true
-- ----------------------------------------------------------------
SELECT id, name, email, is_admin, is_blocked
FROM profiles
WHERE email = 'ravalurugopichand@gmail.com';

-- ================================================================
-- ✅ If you see your row with is_admin = true, you are done!
--    Now go to your app and login again.
--    You will see Admin Panel in your Profile page.
-- ================================================================
