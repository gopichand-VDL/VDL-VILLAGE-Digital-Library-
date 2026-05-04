-- ================================================================
-- STEP 3 (OPTIONAL): MAKE ANOTHER USER AN ADMIN
-- ================================================================
-- Use this anytime you want to give admin access to another person
-- They must have already signed up in your app first
--
-- Replace the email below with the user's email
-- ================================================================

UPDATE profiles
SET is_admin = TRUE
WHERE email = 'REPLACE_WITH_USER_EMAIL';

-- Verify
SELECT id, name, email, is_admin
FROM profiles
WHERE email = 'REPLACE_WITH_USER_EMAIL';

-- ================================================================
-- To REMOVE admin from someone:
-- ================================================================
-- UPDATE profiles
-- SET is_admin = FALSE
-- WHERE email = 'REPLACE_WITH_USER_EMAIL';

-- ================================================================
-- To BLOCK a user:
-- ================================================================
-- UPDATE profiles
-- SET is_blocked = TRUE
-- WHERE email = 'REPLACE_WITH_USER_EMAIL';

-- ================================================================
-- To UNBLOCK a user:
-- ================================================================
-- UPDATE profiles
-- SET is_blocked = FALSE
-- WHERE email = 'REPLACE_WITH_USER_EMAIL';

-- ================================================================
-- To see ALL users:
-- ================================================================
-- SELECT id, name, email, is_admin, is_blocked, books_read, created_at
-- FROM profiles
-- ORDER BY created_at DESC;
