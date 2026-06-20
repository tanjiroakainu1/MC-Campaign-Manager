-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "mcm_users" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "avatar" TEXT,
    "created_at" TEXT NOT NULL,

    CONSTRAINT "mcm_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_campaigns" (
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

    CONSTRAINT "mcm_campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_content_items" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "scheduled_date" TEXT,
    "file_url" TEXT,

    CONSTRAINT "mcm_content_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_campaign_categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "mcm_campaign_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_notifications" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TEXT NOT NULL,

    CONSTRAINT "mcm_notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_audit_logs" (
    "id" TEXT NOT NULL,
    "user" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "resource" TEXT NOT NULL,
    "timestamp" TEXT NOT NULL,

    CONSTRAINT "mcm_audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_tasks" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "assignee_id" TEXT NOT NULL,
    "due_date" TEXT NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "mcm_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_marketing_strategies" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "channels" JSONB NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "mcm_marketing_strategies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_media_assets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "size" TEXT NOT NULL,
    "uploaded_at" TEXT NOT NULL,
    "uploaded_by" TEXT NOT NULL,
    "file_data" TEXT,

    CONSTRAINT "mcm_media_assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_design_assets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "template" TEXT NOT NULL,
    "file_name" TEXT,
    "file_type" TEXT,
    "saved_at" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "mcm_design_assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_settings" (
    "id" TEXT NOT NULL DEFAULT 'global',
    "data" JSONB NOT NULL,
    "updated_at" TEXT NOT NULL,

    CONSTRAINT "mcm_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_campaign_metrics" (
    "campaign_id" TEXT NOT NULL,
    "reach" INTEGER NOT NULL,
    "impressions" INTEGER NOT NULL,
    "clicks" INTEGER NOT NULL,
    "conversions" INTEGER NOT NULL,
    "ctr" DOUBLE PRECISION NOT NULL,
    "conversion_rate" DOUBLE PRECISION NOT NULL,
    "cpc" DOUBLE PRECISION NOT NULL,
    "cpm" DOUBLE PRECISION NOT NULL,
    "revenue" DOUBLE PRECISION NOT NULL,
    "roi" INTEGER NOT NULL,
    "performance_score" INTEGER NOT NULL,
    "updated_at" TEXT NOT NULL,

    CONSTRAINT "mcm_campaign_metrics_pkey" PRIMARY KEY ("campaign_id")
);

-- CreateTable
CREATE TABLE "mcm_design_templates" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "size" TEXT NOT NULL,
    "category" TEXT NOT NULL,

    CONSTRAINT "mcm_design_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcm_user_preferences" (
    "user_id" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "updated_at" TEXT NOT NULL,

    CONSTRAINT "mcm_user_preferences_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "mcm_export_records" (
    "id" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "dataset" TEXT NOT NULL DEFAULT '',
    "format" TEXT NOT NULL,
    "date_range" TEXT NOT NULL DEFAULT '',
    "summary" TEXT NOT NULL,
    "record_count" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "created_at" TEXT NOT NULL,

    CONSTRAINT "mcm_export_records_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "mcm_users_email_key" ON "mcm_users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "mcm_campaign_categories_name_key" ON "mcm_campaign_categories"("name");
