# Campaign Manager — Prisma Database

**Brilliant Copper Skunk** · Database ID: `db_cmqm1alvu0k4k1mf5d4aca2sg`

All tables are in the **`public`** schema with the **`mcm_`** prefix so they appear in **Prisma Console Studio** (schema: public).

## Tables (visible in Prisma Studio)

| Prisma model        | Table name                   |
|---------------------|------------------------------|
| `User`              | `mcm_users`                  |
| `Campaign`          | `mcm_campaigns`              |
| `Content`           | `mcm_content_items`          |
| `CampaignCategory`  | `mcm_campaign_categories`    |
| `Notification`      | `mcm_notifications`        |
| `AuditLog`          | `mcm_audit_logs`             |
| `Task`              | `mcm_tasks`                  |
| `Strategy`          | `mcm_marketing_strategies`   |
| `MediaFile`         | `mcm_media_assets`           |
| `Design`            | `mcm_design_assets`          |
| `SystemSetting`     | `mcm_settings`               |
| `CampaignMetric`    | `mcm_campaign_metrics`       |
| `DesignTemplate`    | `mcm_design_templates`       |
| `UserPreference`    | `mcm_user_preferences`       |
| `ExportRecord`      | `mcm_export_records`         |

Connection strings are in `.env` and `.env.example`.

## Commands

```bash
npm run db:generate
npm run db:push          # local dev schema sync
npm run db:deploy        # production migrations (Prisma Platform)
npm run db:seed
npm run db:studio
```

Production uses `prisma/migrations/20250620180000_baseline_public_mcm` — the live DB was baselined with `prisma migrate resolve --applied`.

In Prisma Console, keep **schema: public** — you should see all `mcm_*` tables.
