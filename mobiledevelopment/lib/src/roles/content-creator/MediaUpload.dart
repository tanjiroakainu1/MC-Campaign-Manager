import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class MediaUpload extends StatefulWidget {
  const MediaUpload({super.key});
  @override
  State<MediaUpload> createState() => _MediaUploadState();
}

class _MediaUploadState extends State<MediaUpload> {
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final media = dataStore.getMedia();
    return AppScreen(children: [
      const PageHeader(title: 'Upload Media', description: 'Upload images and videos for campaigns'),
      AppCard(
        child: InkWell(
          onTap: _pickFile,
          child: const SizedBox(height: 120, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_upload, size: 40), Text('Tap to browse files (image/video)')]))),
        ),
      ),
      ...media.map((file) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Row(children: [
            Text(file.type == 'video' ? '🎬' : '🖼️', style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text(file.name)),
          ]),
          subtitle: Text('${file.size} · ${file.uploadedAt}'),
          trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
            await dataStore.deleteMedia(file.id);
            showToast(context, 'Media deleted');
            setState(() {});
          }),
        ),
      )),
    ]);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final user = context.read<AuthProvider>().user!;
    await dataStore.addMedia({
      'name': file.name,
      'type': file.extension == 'mp4' ? 'video' : 'image',
      'size': '${((file.size ?? 0) / 1024).toStringAsFixed(1)} KB',
      'uploadedAt': DateTime.now().toIso8601String().split('T').first,
      'uploadedBy': user.id,
    }, user.name);
    if (mounted) { showToast(context, 'Media uploaded'); setState(() {}); }
  }
}
