-- Campaign Manager schema — isolated from election tables in public

CREATE SCHEMA IF NOT EXISTS "mcm";

CREATE TABLE IF NOT EXISTS "mcm"."users" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "avatar" TEXT,
    "created_at" TEXT NOT NULL,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX IF NOT EXISTS "users_email_key" ON "mcm"."users"("email");

CREATE TABLE IF NOT EXISTS "mcm"."campaigns" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "budget" DOUBLE PRECISION NOT NULL,
    "spent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "start_date" TEXT NOT NULL,
    "end_date" TEXT NOT NULL,
    "channels" JSONB NOT NULL,
    "manager_id" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."content_items" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "scheduled_date" TEXT,
    "file_url" TEXT,
    CONSTRAINT "content_items_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."campaign_categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    CONSTRAINT "campaign_categories_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX IF NOT EXISTS "campaign_categories_name_key" ON "mcm"."campaign_categories"("name");

CREATE TABLE IF NOT EXISTS "mcm"."notifications" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TEXT NOT NULL,
    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."audit_logs" (
    "id" TEXT NOT NULL,
    "user" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "resource" TEXT NOT NULL,
    "timestamp" TEXT NOT NULL,
    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."tasks" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "assignee_id" TEXT NOT NULL,
    "due_date" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    CONSTRAINT "tasks_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."marketing_strategies" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "channels" JSONB NOT NULL,
    "status" TEXT NOT NULL,
    CONSTRAINT "marketing_strategies_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."media_assets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "size" TEXT NOT NULL,
    "uploaded_at" TEXT NOT NULL,
    "uploaded_by" TEXT NOT NULL,
    CONSTRAINT "media_assets_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mcm"."design_assets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "template" TEXT NOT NULL,
    "file_name" TEXT,
    "file_type" TEXT,
    "saved_at" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    CONSTRAINT "design_assets_pkey" PRIMARY KEY ("id")
);

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'marketing' AND table_name = 'User') THEN
    INSERT INTO "mcm"."users" SELECT "id","name","email","password","role","status","avatar","createdAt" FROM "marketing"."User" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."campaigns" SELECT "id","name","category","status","budget","spent","startDate","endDate","channels","managerId","description" FROM "marketing"."Campaign" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."content_items" SELECT "id","title","type","campaignId","status","createdBy","scheduledDate","fileUrl" FROM "marketing"."Content" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."campaign_categories" SELECT "id","name","description" FROM "marketing"."CampaignCategory" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."notifications" SELECT "id","title","message","type","read","createdAt" FROM "marketing"."Notification" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."audit_logs" SELECT "id","user","action","resource","timestamp" FROM "marketing"."AuditLog" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."tasks" SELECT "id","title","campaignId","assigneeId","dueDate","status" FROM "marketing"."Task" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."marketing_strategies" SELECT "id","name","description","channels","status" FROM "marketing"."Strategy" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."media_assets" SELECT "id","name","type","size","uploadedAt","uploadedBy" FROM "marketing"."MediaFile" ON CONFLICT DO NOTHING;
    INSERT INTO "mcm"."design_assets" SELECT "id","name","template","fileName","fileType","savedAt","createdBy","status" FROM "marketing"."Design" ON CONFLICT DO NOTHING;
  END IF;
END $$;
