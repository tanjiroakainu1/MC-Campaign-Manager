import 'package:flutter/material.dart';
import '../styles/theme.dart';

/// Breakpoints aligned with web Tailwind (sm/md/lg).
class AppBreakpoints {
  static const double sm = 480;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isNarrow => screenWidth < AppBreakpoints.sm;
  bool get isMobile => screenWidth < AppBreakpoints.md;
  bool get isTablet => screenWidth >= AppBreakpoints.md && screenWidth < AppBreakpoints.lg;
  bool get isDesktop => screenWidth >= AppBreakpoints.lg;

  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : isTablet ? 20 : 24,
        vertical: isMobile ? 12 : 16,
      );

  int statGridColumns() {
    if (screenWidth >= AppBreakpoints.xl) return 4;
    if (screenWidth >= AppBreakpoints.sm) return 2;
    return 1;
  }

  int actionGridColumns() {
    if (screenWidth >= AppBreakpoints.lg) return 3;
    if (screenWidth >= AppBreakpoints.md) return 2;
    return 1;
  }

  double statCardAspectRatio() {
    final cols = statGridColumns();
    if (cols == 1) return 2.6;
    if (cols == 2) return isMobile ? 2.2 : 1.9;
    return 1.6;
  }

  double actionCardAspectRatio() {
    final cols = actionGridColumns();
    return cols == 1 ? 3.2 : 2.8;
  }

  bool get stackChartLegend => screenWidth < AppBreakpoints.md;
  bool get compactHeader => screenWidth < AppBreakpoints.md;
}

/// Centers content on large screens with max width (like web max-w-7xl).
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: padding ?? context.pagePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Title + optional action — stacks vertically on narrow screens.
class ResponsivePageHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? action;

  const ResponsivePageHeader({super.key, required this.title, this.description, this.action});

  @override
  Widget build(BuildContext context) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.isMobile ? 20 : 24,
              ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
          Text(description!, style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: context.isMobile ? 13 : 14)),
        ],
      ],
    );

    if (action == null) {
      return Padding(
        padding: EdgeInsets.only(bottom: context.isMobile ? 14 : 18),
        child: _titleBlock(context, titleBlock),
      );
    }

    if (context.isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _titleBlock(context, titleBlock),
            const SizedBox(height: 12),
            action!,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _titleBlock(context, titleBlock)),
          const SizedBox(width: 12),
          action!,
        ],
      ),
    );
  }

  Widget _titleBlock(BuildContext context, Widget titleBlock) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: context.isMobile ? 36 : 42,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.brand500, AppColors.diamond400],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: titleBlock),
      ],
    );
  }
}

/// Row that becomes Column on narrow screens.
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final bool stackOnMobile;
  final double spacing;
  final CrossAxisAlignment columnAlignment;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.stackOnMobile = true,
    this.spacing = 12,
    this.columnAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    if (stackOnMobile && context.isMobile) {
      return Column(
        crossAxisAlignment: columnAlignment,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

/// List row that stacks label + actions on mobile.
class ResponsiveListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  const ResponsiveListTile({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    if (context.isMobile && trailing != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
            const SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: trailing!),
          ],
        ),
      );
    }
    return Row(
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
    );
  }
}

/// Button groups that wrap on narrow screens instead of overflowing.
class ResponsiveButtonRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  const ResponsiveButtonRow({
    super.key,
    required this.children,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, alignment: alignment, children: children);
  }
}

/// Chart grid — single column on mobile, two columns on tablet+.
class ResponsiveChartGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const ResponsiveChartGrid({super.key, required this.children, this.spacing = 12});

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((c) => SizedBox(width: half, child: c)).toList(),
        );
      },
    );
  }
}
