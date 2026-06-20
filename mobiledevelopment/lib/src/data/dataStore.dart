import '../lib/api.dart';
import '../types/index.dart';

class AppData {
  final List<User> users;
  final List<Campaign> campaigns;
  final List<Content> content;
  final List<CampaignCategory> categories;
  final List<NotificationItem> notifications;
  final List<AuditLog> auditLogs;
  final List<Task> tasks;
  final List<Strategy> strategies;
  final List<MediaFile> media;
  final List<Design> designs;
  final SystemSettings settings;
  final List<CampaignMetric> metrics;
  final List<DesignTemplate> templates;
  final List<UserPreference> preferences;
  final List<ExportRecord> exportRecords;

  const AppData({
    required this.users,
    required this.campaigns,
    required this.content,
    required this.categories,
    required this.notifications,
    required this.auditLogs,
    required this.tasks,
    required this.strategies,
    required this.media,
    required this.designs,
    required this.settings,
    required this.metrics,
    required this.templates,
    required this.preferences,
    required this.exportRecords,
  });

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        users: (json['users'] as List).map((e) => User.fromJson(e)).toList(),
        campaigns: (json['campaigns'] as List).map((e) => Campaign.fromJson(e)).toList(),
        content: (json['content'] as List).map((e) => Content.fromJson(e)).toList(),
        categories: (json['categories'] as List).map((e) => CampaignCategory.fromJson(e)).toList(),
        notifications: (json['notifications'] as List).map((e) => NotificationItem.fromJson(e)).toList(),
        auditLogs: (json['auditLogs'] as List).map((e) => AuditLog.fromJson(e)).toList(),
        tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
        strategies: (json['strategies'] as List).map((e) => Strategy.fromJson(e)).toList(),
        media: (json['media'] as List).map((e) => MediaFile.fromJson(e)).toList(),
        designs: (json['designs'] as List).map((e) => Design.fromJson(e)).toList(),
        settings: SystemSettings.fromJson(json['settings'] as Map<String, dynamic>? ?? {}),
        metrics: (json['metrics'] as List? ?? []).map((e) => CampaignMetric.fromJson(e)).toList(),
        templates: (json['templates'] as List? ?? []).map((e) => DesignTemplate.fromJson(e)).toList(),
        preferences: (json['preferences'] as List? ?? []).map((e) => UserPreference.fromJson(e)).toList(),
        exportRecords: (json['exportRecords'] as List? ?? []).map((e) => ExportRecord.fromJson(e)).toList(),
      );
}

class DataStore {
  AppData? _cache;
  final List<void Function()> _listeners = [];

  void addListener(void Function() fn) => _listeners.add(fn);
  void removeListener(void Function() fn) => _listeners.remove(fn);
  void _notify() {
    for (final fn in List.of(_listeners)) fn();
  }

  bool get isReady => _cache != null;
  List<User> getCachedUsers() => _cache?.users ?? [];

  void setCacheUsers(List<User> users) {
    if (_cache == null) return;
    _cache = AppData(
      users: users,
      campaigns: _cache!.campaigns,
      content: _cache!.content,
      categories: _cache!.categories,
      notifications: _cache!.notifications,
      auditLogs: _cache!.auditLogs,
      tasks: _cache!.tasks,
      strategies: _cache!.strategies,
      media: _cache!.media,
      designs: _cache!.designs,
      settings: _cache!.settings,
      metrics: _cache!.metrics,
      templates: _cache!.templates,
      preferences: _cache!.preferences,
      exportRecords: _cache!.exportRecords,
    );
  }

  Future<void> hydrate() async {
    final data = await apiFetch<Map<String, dynamic>>('/sync');
    _cache = AppData.fromJson(data);
    _notify();
  }

  Future<void> reload() async => hydrate();

  void _syncCategoryCounts() {
    if (_cache == null) return;
    final cats = _cache!.categories.map((cat) {
      final count = _cache!.campaigns.where((c) => c.category == cat.name).length;
      return CampaignCategory(id: cat.id, name: cat.name, description: cat.description, campaignCount: count);
    }).toList();
    _cache = AppData(
      users: _cache!.users,
      campaigns: _cache!.campaigns,
      content: _cache!.content,
      categories: cats,
      notifications: _cache!.notifications,
      auditLogs: _cache!.auditLogs,
      tasks: _cache!.tasks,
      strategies: _cache!.strategies,
      media: _cache!.media,
      designs: _cache!.designs,
      settings: _cache!.settings,
      metrics: _cache!.metrics,
      templates: _cache!.templates,
      preferences: _cache!.preferences,
      exportRecords: _cache!.exportRecords,
    );
  }

  List<Campaign> getCampaigns() => _cache?.campaigns ?? [];
  Campaign? getCampaignById(String id) {
    try {
      return getCampaigns().firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Campaign> addCampaign(Map<String, dynamic> campaign, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/campaigns', method: 'POST', body: {'campaign': campaign, 'actor': actor});
    await reload();
    return Campaign.fromJson(data);
  }

  Future<Campaign?> updateCampaign(String id, Map<String, dynamic> updates, [String actor = 'System']) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/campaigns/$id', method: 'PATCH', body: {'updates': updates, 'actor': actor});
      await reload();
      return Campaign.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteCampaign(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/campaigns/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Content> getContent() => _cache?.content ?? [];
  List<Content> getContentByUser(String userId) => getContent().where((c) => c.createdBy == userId).toList();

  Future<Content> addContent(Map<String, dynamic> item, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/content', method: 'POST', body: {'item': item, 'actor': actor});
    await reload();
    return Content.fromJson(data);
  }

  Future<Content?> updateContent(String id, Map<String, dynamic> updates, [String actor = 'System']) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/content/$id', method: 'PATCH', body: {'updates': updates, 'actor': actor});
      await reload();
      return Content.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteContent(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/content/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<CampaignCategory> getCategories() {
    _syncCategoryCounts();
    return _cache?.categories ?? [];
  }

  Future<CampaignCategory> addCategory(Map<String, dynamic> cat, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/categories', method: 'POST', body: {'category': cat, 'actor': actor});
    await reload();
    return CampaignCategory.fromJson(data);
  }

  Future<bool> updateCategory(String id, Map<String, dynamic> updates, [String actor = 'System']) async {
    try {
      await apiFetch('/categories/$id', method: 'PATCH', body: {'updates': updates, 'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/categories/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Task> getTasks() => _cache?.tasks ?? [];

  Future<Task> addTask(Map<String, dynamic> task, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/tasks', method: 'POST', body: {'task': task, 'actor': actor});
    await reload();
    return Task.fromJson(data);
  }

  Future<Task?> updateTask(String id, Map<String, dynamic> updates) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/tasks/$id', method: 'PATCH', body: {'updates': updates});
      await reload();
      return Task.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteTask(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/tasks/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Strategy> getStrategies() => _cache?.strategies ?? [];

  Future<Strategy> addStrategy(Map<String, dynamic> strategy, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/strategies', method: 'POST', body: {'strategy': strategy, 'actor': actor});
    await reload();
    return Strategy.fromJson(data);
  }

  Future<Strategy?> updateStrategy(String id, Map<String, dynamic> updates) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/strategies/$id', method: 'PATCH', body: {'updates': updates});
      await reload();
      return Strategy.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteStrategy(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/strategies/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<MediaFile> getMedia() => _cache?.media ?? [];

  Future<MediaFile> addMedia(Map<String, dynamic> file, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/media', method: 'POST', body: {'file': file, 'actor': actor});
    await reload();
    return MediaFile.fromJson(data);
  }

  Future<bool> deleteMedia(String id) async {
    try {
      await apiFetch('/media/$id', method: 'DELETE');
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Design> getDesigns() => _cache?.designs ?? [];
  List<Design> getDesignsByUser(String userId) => getDesigns().where((d) => d.createdBy == userId).toList();

  Future<Design> addDesign(Map<String, dynamic> design, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/designs', method: 'POST', body: {'design': design, 'actor': actor});
    await reload();
    return Design.fromJson(data);
  }

  Future<Design?> updateDesign(String id, Map<String, dynamic> updates, [String actor = 'System']) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/designs/$id', method: 'PATCH', body: {'updates': updates, 'actor': actor});
      await reload();
      return Design.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteDesign(String id, [String actor = 'System']) async {
    try {
      await apiFetch('/designs/$id', method: 'DELETE', body: {'actor': actor});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<NotificationItem> getNotifications() => _cache?.notifications ?? [];
  List<AuditLog> getAuditLogs() => _cache?.auditLogs ?? [];

  Future<bool> markNotificationRead(String id) async {
    try {
      await apiFetch('/notifications/$id', method: 'PATCH', body: {'read': true});
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markAllNotificationsRead() async {
    try {
      await apiFetch('/notifications/mark-all-read', method: 'PATCH');
      await reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  SystemSettings getSettings() => _cache?.settings ?? const SystemSettings(
        companyName: 'Acme Marketing Corp',
        timezone: 'America/New_York',
        currency: 'PHP',
        emailNotifications: true,
        smsNotifications: false,
        autoBackup: true,
        backupFrequency: 'daily',
        sessionTimeout: '30',
        maxUploadSize: '50',
      );

  Future<SystemSettings> updateSettings(Map<String, dynamic> updates, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/settings', method: 'PATCH', body: {'settings': updates, 'actor': actor});
    await reload();
    return SystemSettings.fromJson(data);
  }

  CampaignMetric? _metricFor(String campaignId) {
    try {
      return _cache?.metrics.firstWhere((m) => m.campaignId == campaignId);
    } catch (_) {
      return null;
    }
  }

  ({double revenue, int roi}) computeCampaignROI(Campaign campaign) {
    final m = _metricFor(campaign.id);
    if (m != null) return (revenue: m.revenue, roi: m.roi);
    return (revenue: 0, roi: 0);
  }

  int computePerformanceScore(String campaignId) => _metricFor(campaignId)?.performanceScore ?? 0;

  Map<String, dynamic>? getCampaignMetrics(String campaignId) {
    final m = _metricFor(campaignId);
    if (m == null) return null;
    return {
      'reach': m.reach,
      'impressions': m.impressions,
      'clicks': m.clicks,
      'conversions': m.conversions,
      'ctr': m.ctr,
      'conversionRate': m.conversionRate,
      'cpc': m.cpc,
      'cpm': m.cpm,
    };
  }

  List<CampaignMetric> getAllMetrics() => _cache?.metrics ?? [];

  List<DesignTemplate> getDesignTemplates() => _cache?.templates ?? [];

  Map<String, bool> getUserPreferences(String userId) {
    try {
      final pref = _cache!.preferences.firstWhere((p) => p.userId == userId);
      return Map<String, bool>.from(pref.data['dashboardWidgets'] as Map? ?? {});
    } catch (_) {
      return {'w1': true, 'w2': true, 'w3': true, 'w4': true, 'charts': true, 'spend': true, 'content': true, 'pending': true};
    }
  }

  Future<void> updateUserPreferences(String userId, Map<String, bool> widgets) async {
    await apiFetch('/preferences/$userId', method: 'PATCH', body: {'data': {'dashboardWidgets': widgets}});
    await reload();
  }

  List<ExportRecord> getExportRecords() => _cache?.exportRecords ?? [];

  Future<ExportRecord> createExportRecord(Map<String, dynamic> record, [String actor = 'System']) async {
    final data = await apiFetch<Map<String, dynamic>>('/exports', method: 'POST', body: {'record': record, 'actor': actor});
    await reload();
    return ExportRecord.fromJson(data);
  }
}

final dataStore = DataStore();
