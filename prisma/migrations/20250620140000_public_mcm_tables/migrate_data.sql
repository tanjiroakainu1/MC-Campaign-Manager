-- Move Campaign Manager data from mcm schema into public.mcm_* tables

INSERT INTO "public"."mcm_users" ("id","name","email","password","role","status","avatar","created_at")
SELECT "id","name","email","password","role","status","avatar","created_at" FROM "mcm"."users"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_campaigns" ("id","name","category","status","budget","spent","start_date","end_date","channels","manager_id","description")
SELECT "id","name","category","status","budget","spent","start_date","end_date","channels","manager_id","description" FROM "mcm"."campaigns"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_content_items" ("id","title","type","campaign_id","status","created_by","scheduled_date","file_url")
SELECT "id","title","type","campaign_id","status","created_by","scheduled_date","file_url" FROM "mcm"."content_items"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_campaign_categories" ("id","name","description")
SELECT "id","name","description" FROM "mcm"."campaign_categories"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_notifications" ("id","title","message","type","read","created_at")
SELECT "id","title","message","type","read","created_at" FROM "mcm"."notifications"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_audit_logs" ("id","user","action","resource","timestamp")
SELECT "id","user","action","resource","timestamp" FROM "mcm"."audit_logs"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_tasks" ("id","title","campaign_id","assignee_id","due_date","status")
SELECT "id","title","campaign_id","assignee_id","due_date","status" FROM "mcm"."tasks"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_marketing_strategies" ("id","name","description","channels","status")
SELECT "id","name","description","channels","status" FROM "mcm"."marketing_strategies"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_media_assets" ("id","name","type","size","uploaded_at","uploaded_by")
SELECT "id","name","type","size","uploaded_at","uploaded_by" FROM "mcm"."media_assets"
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "public"."mcm_design_assets" ("id","name","template","file_name","file_type","saved_at","created_by","status")
SELECT "id","name","template","file_name","file_type","saved_at","created_by","status" FROM "mcm"."design_assets"
ON CONFLICT ("id") DO NOTHING;
