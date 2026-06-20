import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../utils/responsive.dart';

enum ModalSize { sm, md, lg }

class AppModal extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final String title;
  final Widget child;
  final ModalSize size;

  const AppModal({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.title,
    required this.child,
    this.size = ModalSize.md,
  });

  double _maxWidth(ModalSize size) {
    switch (size) {
      case ModalSize.sm:
        return 400;
      case ModalSize.lg:
        return 720;
      case ModalSize.md:
        return 520;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      child: GestureDetector(
        onTap: onClose,
        child: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.isMobile ? MediaQuery.sizeOf(context).width - 24 : _maxWidth(size),
                  maxHeight: MediaQuery.sizeOf(context).height * 0.9,
                ),
                child: Card(
                  margin: const EdgeInsets.all(16),
                  clipBehavior: Clip.antiAlias,
                  elevation: 8,
                  shadowColor: AppColors.brand900.withValues(alpha: 0.2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.brand800, AppColors.brand700],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: onClose,
                              icon: const Icon(Icons.close, color: Colors.white70),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                      Flexible(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: child)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
