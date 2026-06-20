import 'package:flutter/material.dart';
import '../config/developer.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';

enum DeveloperCreditVariant { hero, footerDark, footerLight, sidebar, card, inline }

class DeveloperCredit extends StatelessWidget {
  final DeveloperCreditVariant variant;

  const DeveloperCredit({super.key, this.variant = DeveloperCreditVariant.inline});

  @override
  Widget build(BuildContext context) {
    final name = developer['name'] as String;
    final role = developer['role'] as String;
    final title = developer['title'] as String;
    final tagline = developer['tagline'] as String;
    final initials = developer['initials'] as String;
    final version = developer['version'] as String;
    final stack = (developer['stack'] as List).cast<String>();
    final year = developer['year'] as String;

    switch (variant) {
      case DeveloperCreditVariant.hero:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Card(
            color: Colors.white.withValues(alpha: 0.95),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _avatar(initials, size: 80),
                  const SizedBox(height: 16),
                  Text('MEET THE DEVELOPER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.brand600)),
                  const SizedBox(height: 8),
                  Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.slate900)),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand600)),
                  const SizedBox(height: 12),
                  Text('$tagline. This entire Marketing Campaign Management System — every dashboard, role, sidebar, and pixel — was designed and built from the ground up.', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.slate500, height: 1.5)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: stack.map((tech) => Chip(label: Text(tech, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      case DeveloperCreditVariant.footerDark:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _avatar(initials, size: 24, fontSize: 10),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'by $name · v$version',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        );
      case DeveloperCreditVariant.footerLight:
        return LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < AppBreakpoints.md;
            final content = stacked
                ? Column(
                    children: [
                      Row(
                        children: [
                          _avatar(initials, size: 32),
                          const SizedBox(width: 10),
                          Expanded(child: Text('Built by $name · $role', style: const TextStyle(fontSize: 12, color: AppColors.slate500))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('© $year Campaign Manager', style: const TextStyle(fontSize: 11, color: AppColors.slate500)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _avatar(initials, size: 32),
                          const SizedBox(width: 10),
                          Text('Built by $name · $role', style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                        ],
                      ),
                      Text('© $year Campaign Manager', style: const TextStyle(fontSize: 11, color: AppColors.slate500)),
                    ],
                  );
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(stacked ? 12 : 16),
              decoration: BoxDecoration(
                color: AppColors.brand50.withValues(alpha: 0.5),
                border: const Border(top: BorderSide(color: AppColors.brand100)),
              ),
              child: content,
            );
          },
        );
      case DeveloperCreditVariant.sidebar:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.brand50.withValues(alpha: 0.8), AppColors.diamond100.withValues(alpha: 0.6)]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.brand100),
          ),
          child: Row(
            children: [
              _avatar(initials, size: 28, fontSize: 9),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DEVELOPER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.brand600, letterSpacing: 1)),
                    Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      case DeveloperCreditVariant.card:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _avatar(initials, size: 64),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SYSTEM DEVELOPER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.brand600, letterSpacing: 1.5)),
                          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          Text(title, style: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('$tagline.', style: const TextStyle(color: AppColors.slate500)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: stack.map((t) => Chip(label: Text(t))).toList()),
              ],
            ),
          ),
        );
      case DeveloperCreditVariant.inline:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.code, size: 14, color: AppColors.brand500),
            const SizedBox(width: 4),
            Text('$name · $role', style: const TextStyle(fontSize: 12, color: AppColors.slate500, fontWeight: FontWeight.w600)),
          ],
        );
    }
  }

  Widget _avatar(String initials, {required double size, double fontSize = 14}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.brand500, AppColors.diamond400]),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Text(initials, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: fontSize)),
    );
  }
}
