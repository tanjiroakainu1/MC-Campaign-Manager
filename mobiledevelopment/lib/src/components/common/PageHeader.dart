import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? action;

  const PageHeader({super.key, required this.title, this.description, this.action});

  @override
  Widget build(BuildContext context) {
    return ResponsivePageHeader(title: title, description: description, action: action);
  }
}
