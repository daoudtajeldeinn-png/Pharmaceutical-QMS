-- Supabase Schema Fix (v7 - Final TestResults fix)
-- Adds the remaining missing columns for testResults.

ALTER TABLE "testResults"
  ADD COLUMN IF NOT EXISTS "batchNumber" text,
  ADD COLUMN IF NOT EXISTS "batchnumber" text,
  ADD COLUMN IF NOT EXISTS "testDate" text,
  ADD COLUMN IF NOT EXISTS "testdate" text,
  ADD COLUMN IF NOT EXISTS "status" text,
  ADD COLUMN IF NOT EXISTS "notes" text;

NOTIFY pgrst, 'reload schema';
