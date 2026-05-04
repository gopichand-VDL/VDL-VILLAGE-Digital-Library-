-- ================================================================
-- USEFUL QUERIES — Run anytime to check your library data
-- ================================================================
-- Copy any single query below and run it in SQL Editor
-- ================================================================

-- ── CHECK ALL USERS ──────────────────────────────────────────────
SELECT id, name, email, is_admin, is_blocked, books_read, created_at
FROM profiles
ORDER BY created_at DESC;


-- ── CHECK ALL BOOKS ──────────────────────────────────────────────
SELECT b.title, b.author, c.name AS category, b.reads, b.avg_rating,
       b.is_featured, b.is_trending, b.created_at
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
ORDER BY b.created_at DESC;


-- ── CHECK ALL CATEGORIES ─────────────────────────────────────────
SELECT icon, name, id, created_at
FROM categories
ORDER BY name;


-- ── TOP 10 MOST READ BOOKS ───────────────────────────────────────
SELECT title, author, reads, avg_rating
FROM books
ORDER BY reads DESC
LIMIT 10;


-- ── COUNT EVERYTHING ─────────────────────────────────────────────
SELECT
  (SELECT COUNT(*) FROM profiles)         AS total_users,
  (SELECT COUNT(*) FROM books)            AS total_books,
  (SELECT COUNT(*) FROM categories)       AS total_categories,
  (SELECT COUNT(*) FROM comments)         AS total_comments,
  (SELECT COUNT(*) FROM reading_history)  AS total_reads,
  (SELECT COUNT(*) FROM download_history) AS total_downloads,
  (SELECT COUNT(*) FROM notifications)    AS total_notifications;


-- ── CHECK ALL COMMENTS ───────────────────────────────────────────
SELECT c.content, p.name AS user, b.title AS book, c.created_at
FROM comments c
JOIN profiles p ON c.user_id = p.id
JOIN books b ON c.book_id = b.id
ORDER BY c.created_at DESC
LIMIT 50;


-- ── DELETE A SPECIFIC BOOK (replace the title) ───────────────────
-- DELETE FROM books WHERE title = 'BOOK TITLE HERE';


-- ── DELETE ALL NOTIFICATIONS (clean up) ──────────────────────────
-- DELETE FROM notifications;


-- ── DELETE ALL COMMENTS FOR A BOOK ───────────────────────────────
-- DELETE FROM comments WHERE book_id = (
--   SELECT id FROM books WHERE title = 'BOOK TITLE HERE'
-- );


-- ── RESET A USER PASSWORD (use Auth panel instead) ───────────────
-- Not possible via SQL — use Supabase Auth → Users → Send reset email


-- ── ADMIN LOG HISTORY ────────────────────────────────────────────
SELECT al.action, al.details, p.name AS admin, al.created_at
FROM admin_logs al
LEFT JOIN profiles p ON al.user_id = p.id
ORDER BY al.created_at DESC
LIMIT 100;


-- ── VERIFY ADMIN STATUS ──────────────────────────────────────────
SELECT name, email, is_admin
FROM profiles
WHERE is_admin = TRUE;


-- ── CHECK ANNOUNCEMENTS SENT ─────────────────────────────────────
SELECT a.title, a.body, p.name AS sent_by, a.created_at
FROM announcements a
LEFT JOIN profiles p ON a.sent_by = p.id
ORDER BY a.created_at DESC;
