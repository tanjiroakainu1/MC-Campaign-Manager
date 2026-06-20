import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../utils/responsive.dart';

/// Consistent vertical spacing between page sections.
const double kSectionGap = 20;
const double kFieldGap = 14;

/// Wraps dashboard / feature page content with uniform section spacing.
class AppScreen extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const AppScreen({super.key, required this.children, this.spacing = kSectionGap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          children[i],
        ],
      ],
    );
  }
}

/// Section title used for "Quick Actions", "Recent Campaigns", etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const SectionHeader({super.key, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: context.isMobile ? 16 : 18,
      fontWeight: FontWeight.w800,
      color: AppColors.slate900,
      letterSpacing: -0.2,
    );

    final accent = Container(
      width: 4,
      height: context.isMobile ? 18 : 20,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.brand500, AppColors.diamond400],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );

    final titleRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        accent,
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: titleStyle)),
        if (action != null) action!,
      ],
    );

    if (subtitle == null) return titleRow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleRow,
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 6),
          child: Text(subtitle!, style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.4)),
        ),
      ],
    );
  }
}

/// Polished card with optional header and consistent padding.
class AppCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final inner = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    if (title == null) {
      return Card(child: inner);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 14 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: context.isMobile ? 15 : 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate900,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
            inner,
          ],
        ),
      ),
    );
  }
}

/// A single row inside an AppCard list — with optional divider.
class AppListItem extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool showDivider;

  const AppListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: context.isMobile && trailing != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: trailing!),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.brand100.withValues(alpha: 0.9)),
      ],
    );
  }
}

/// Form fields with consistent vertical gaps.
class FormSection extends StatelessWidget {
  final List<Widget> children;
  final double gap;

  const FormSection({super.key, required this.children, this.gap = kFieldGap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// Subtle info banner for insights / tips.
class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;

  const InfoBanner({super.key, required this.message, this.icon = Icons.info_outline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brand50, AppColors.diamond100.withValues(alpha: 0.5)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brand100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.brand600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.slate700, height: 1.45)),
          ),
        ],
      ),
    );
  }
}
