-- Run once in Supabase SQL Editor to enable cross-device deletion tombstones.
-- Fixes: REST 404 on /rest/v1/deletedRecords

CREATE TABLE IF NOT EXISTS "deletedRecords" (
  "id" text PRIMARY KEY,
  "record_id" text NOT NULL,
  "table_name" text NOT NULL,
  "deleted_at" text NOT NULL,
  "deleted_by" text NOT NULL,
  "reason" text,
  "snapshot" text,
  "recovered" boolean DEFAULT false,
  "recovered_by" text,
  "recovered_at" text
);

ALTER TABLE "deletedRecords" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all for authenticated" ON "deletedRecords";
CREATE POLICY "Allow all for authenticated" ON "deletedRecords"
  FOR ALL USING (true) WITH CHECK (true);

GRANT ALL ON "deletedRecords" TO authenticated;
GRANT ALL ON "deletedRecords" TO anon;

NOTIFY pgrst, 'reload schema';
