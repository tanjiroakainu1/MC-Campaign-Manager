typedef UserRole = String;

class UserRoles {
  static const superAdmin = 'super-admin';
  static const marketingManager = 'marketing-manager';
  static const contentCreator = 'content-creator';
  static const marketingAnalyst = 'marketing-analyst';
}

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? avatar;
  final String createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        status: json['status'] as String,
        avatar: json['avatar'] as String?,
        createdAt: json['createdAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'status': status,
        'avatar': avatar,
        'createdAt': createdAt,
      };

  User copyWith({String? name, String? email, String? role, String? status}) => User(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        status: status ?? this.status,
        avatar: avatar,
        createdAt: createdAt,
      );
}

class Campaign {
  final String id;
  final String name;
  final String category;
  final String status;
  final double budget;
  final double spent;
  final String startDate;
  final String endDate;
  final List<String> channels;
  final String managerId;
  final String description;

  const Campaign({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.budget,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.channels,
    required this.managerId,
    required this.description,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        status: json['status'] as String,
        budget: (json['budget'] as num).toDouble(),
        spent: (json['spent'] as num).toDouble(),
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        channels: (json['channels'] as List).map((e) => e.toString()).toList(),
        managerId: json['managerId'] as String,
        description: json['description'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'status': status,
        'budget': budget,
        'spent': spent,
        'startDate': startDate,
        'endDate': endDate,
        'channels': channels,
        'managerId': managerId,
        'description': description,
      };

  Campaign copyWith({String? status, double? budget, double? spent}) => Campaign(
        id: id,
        name: name,
        category: category,
        status: status ?? this.status,
        budget: budget ?? this.budget,
        spent: spent ?? this.spent,
        startDate: startDate,
        endDate: endDate,
        channels: channels,
        managerId: managerId,
        description: description,
      );
}

class Content {
  final String id;
  final String title;
  final String type;
  final String campaignId;
  final String status;
  final String createdBy;
  final String? scheduledDate;
  final String? fileUrl;

  const Content({
    required this.id,
    required this.title,
    required this.type,
    required this.campaignId,
    required this.status,
    required this.createdBy,
    this.scheduledDate,
    this.fileUrl,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        campaignId: json['campaignId'] as String,
        status: json['status'] as String,
        createdBy: json['createdBy'] as String,
        scheduledDate: json['scheduledDate'] as String?,
        fileUrl: json['fileUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'campaignId': campaignId,
        'status': status,
        'createdBy': createdBy,
        if (scheduledDate != null) 'scheduledDate': scheduledDate,
        if (fileUrl != null) 'fileUrl': fileUrl,
      };

  Content copyWith({String? title, String? status, String? scheduledDate}) => Content(
        id: id,
        title: title ?? this.title,
        type: type,
        campaignId: campaignId,
        status: status ?? this.status,
        createdBy: createdBy,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        fileUrl: fileUrl,
      );
}

class CampaignCategory {
  final String id;
  final String name;
  final String description;
  final int campaignCount;

  const CampaignCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.campaignCount,
  });

  factory CampaignCategory.fromJson(Map<String, dynamic> json) => CampaignCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        campaignCount: json['campaignCount'] as int? ?? 0,
      );
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String,
        read: json['read'] as bool,
        createdAt: json['createdAt'] as String,
      );
}

class AuditLog {
  final String id;
  final String user;
  final String action;
  final String resource;
  final String timestamp;

  const AuditLog({
    required this.id,
    required this.user,
    required this.action,
    required this.resource,
    required this.timestamp,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
        id: json['id'] as String,
        user: json['user'] as String,
        action: json['action'] as String,
        resource: json['resource'] as String,
        timestamp: json['timestamp'] as String,
      );
}

class Task {
  final String id;
  final String title;
  final String campaignId;
  final String assigneeId;
  final String dueDate;
  final String status;

  const Task({
    required this.id,
    required this.title,
    required this.campaignId,
    required this.assigneeId,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        campaignId: json['campaignId'] as String,
        assigneeId: json['assigneeId'] as String,
        dueDate: json['dueDate'] as String,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'campaignId': campaignId,
        'assigneeId': assigneeId,
        'dueDate': dueDate,
        'status': status,
      };

  Task copyWith({String? status}) => Task(
        id: id,
        title: title,
        campaignId: campaignId,
        assigneeId: assigneeId,
        dueDate: dueDate,
        status: status ?? this.status,
      );
}

class Strategy {
  final String id;
  final String name;
  final String description;
  final List<String> channels;
  final String status;

  const Strategy({
    required this.id,
    required this.name,
    required this.description,
    required this.channels,
    required this.status,
  });

  factory Strategy.fromJson(Map<String, dynamic> json) => Strategy(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        channels: (json['channels'] as List).map((e) => e.toString()).toList(),
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'channels': channels,
        'status': status,
      };
}

class MediaFile {
  final String id;
  final String name;
  final String type;
  final String size;
  final String uploadedAt;
  final String uploadedBy;

  const MediaFile({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        size: json['size'] as String,
        uploadedAt: json['uploadedAt'] as String,
        uploadedBy: json['uploadedBy'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'size': size,
        'uploadedAt': uploadedAt,
        'uploadedBy': uploadedBy,
      };
}

class Design {
  final String id;
  final String name;
  final String template;
  final String? fileName;
  final String? fileType;
  final String savedAt;
  final String createdBy;
  final String status;

  const Design({
    required this.id,
    required this.name,
    required this.template,
    required this.savedAt,
    required this.createdBy,
    required this.status,
    this.fileName,
    this.fileType,
  });

  factory Design.fromJson(Map<String, dynamic> json) => Design(
        id: json['id'] as String,
        name: json['name'] as String,
        template: json['template'] as String,
        fileName: json['fileName'] as String?,
        fileType: json['fileType'] as String?,
        savedAt: json['savedAt'] as String,
        createdBy: json['createdBy'] as String,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'template': template,
        if (fileName != null) 'fileName': fileName,
        if (fileType != null) 'fileType': fileType,
        'savedAt': savedAt,
        'createdBy': createdBy,
        'status': status,
      };
}

class NavItem {
  final String id;
  final String label;
  final String path;

  const NavItem({required this.id, required this.label, required this.path});
}

class SystemSettings {
  final String companyName;
  final String timezone;
  final String currency;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool autoBackup;
  final String backupFrequency;
  final String sessionTimeout;
  final String maxUploadSize;

  const SystemSettings({
    required this.companyName,
    required this.timezone,
    required this.currency,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.autoBackup,
    required this.backupFrequency,
    required this.sessionTimeout,
    required this.maxUploadSize,
  });

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        companyName: json['companyName'] as String? ?? 'Acme Marketing Corp',
        timezone: json['timezone'] as String? ?? 'America/New_York',
        currency: json['currency'] as String? ?? 'PHP',
        emailNotifications: json['emailNotifications'] as bool? ?? true,
        smsNotifications: json['smsNotifications'] as bool? ?? false,
        autoBackup: json['autoBackup'] as bool? ?? true,
        backupFrequency: json['backupFrequency'] as String? ?? 'daily',
        sessionTimeout: json['sessionTimeout'] as String? ?? '30',
        maxUploadSize: json['maxUploadSize'] as String? ?? '50',
      );

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'timezone': timezone,
        'currency': currency,
        'emailNotifications': emailNotifications,
        'smsNotifications': smsNotifications,
        'autoBackup': autoBackup,
        'backupFrequency': backupFrequency,
        'sessionTimeout': sessionTimeout,
        'maxUploadSize': maxUploadSize,
      };

  SystemSettings copyWith({
    String? companyName,
    String? timezone,
    String? currency,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? autoBackup,
    String? backupFrequency,
    String? sessionTimeout,
    String? maxUploadSize,
  }) =>
      SystemSettings(
        companyName: companyName ?? this.companyName,
        timezone: timezone ?? this.timezone,
        currency: currency ?? this.currency,
        emailNotifications: emailNotifications ?? this.emailNotifications,
        smsNotifications: smsNotifications ?? this.smsNotifications,
        autoBackup: autoBackup ?? this.autoBackup,
        backupFrequency: backupFrequency ?? this.backupFrequency,
        sessionTimeout: sessionTimeout ?? this.sessionTimeout,
        maxUploadSize: maxUploadSize ?? this.maxUploadSize,
      );
}

class CampaignMetric {
  final String campaignId;
  final int reach;
  final int impressions;
  final int clicks;
  final int conversions;
  final double ctr;
  final double conversionRate;
  final double cpc;
  final double cpm;
  final double revenue;
  final int roi;
  final int performanceScore;
  final String updatedAt;

  const CampaignMetric({
    required this.campaignId,
    required this.reach,
    required this.impressions,
    required this.clicks,
    required this.conversions,
    required this.ctr,
    required this.conversionRate,
    required this.cpc,
    required this.cpm,
    required this.revenue,
    required this.roi,
    required this.performanceScore,
    required this.updatedAt,
  });

  factory CampaignMetric.fromJson(Map<String, dynamic> json) => CampaignMetric(
        campaignId: json['campaignId'] as String,
        reach: (json['reach'] as num).toInt(),
        impressions: (json['impressions'] as num).toInt(),
        clicks: (json['clicks'] as num).toInt(),
        conversions: (json['conversions'] as num).toInt(),
        ctr: (json['ctr'] as num).toDouble(),
        conversionRate: (json['conversionRate'] as num).toDouble(),
        cpc: (json['cpc'] as num).toDouble(),
        cpm: (json['cpm'] as num).toDouble(),
        revenue: (json['revenue'] as num).toDouble(),
        roi: (json['roi'] as num).toInt(),
        performanceScore: (json['performanceScore'] as num).toInt(),
        updatedAt: json['updatedAt'] as String? ?? '',
      );
}

class DesignTemplate {
  final String id;
  final String name;
  final String size;
  final String category;
  const DesignTemplate({required this.id, required this.name, required this.size, required this.category});
  factory DesignTemplate.fromJson(Map<String, dynamic> json) => DesignTemplate(
        id: json['id'] as String,
        name: json['name'] as String,
        size: json['size'] as String,
        category: json['category'] as String,
      );
}

class UserPreference {
  final String userId;
  final Map<String, dynamic> data;
  final String updatedAt;
  const UserPreference({required this.userId, required this.data, required this.updatedAt});
  factory UserPreference.fromJson(Map<String, dynamic> json) => UserPreference(
        userId: json['userId'] as String,
        data: json['data'] as Map<String, dynamic>? ?? {},
        updatedAt: json['updatedAt'] as String? ?? '',
      );
}

class ExportRecord {
  final String id;
  final String kind;
  final String dataset;
  final String format;
  final String dateRange;
  final String summary;
  final int recordCount;
  final String createdBy;
  final String createdAt;
  const ExportRecord({
    required this.id, required this.kind, required this.dataset, required this.format,
    required this.dateRange, required this.summary, required this.recordCount,
    required this.createdBy, required this.createdAt,
  });
  factory ExportRecord.fromJson(Map<String, dynamic> json) => ExportRecord(
        id: json['id'] as String,
        kind: json['kind'] as String,
        dataset: json['dataset'] as String? ?? '',
        format: json['format'] as String,
        dateRange: json['dateRange'] as String? ?? '',
        summary: json['summary'] as String,
        recordCount: (json['recordCount'] as num).toInt(),
        createdBy: json['createdBy'] as String,
        createdAt: json['createdAt'] as String,
      );
}
