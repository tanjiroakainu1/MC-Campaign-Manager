import 'package:flutter/material.dart';

class SidebarProvider extends ChangeNotifier {
  bool _isOpen = false;
  bool _isCollapsed = false;

  bool get isOpen => _isOpen;
  bool get isCollapsed => _isCollapsed;

  void toggle() => _isOpen ? close() : open();
  void open() {
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    _isOpen = false;
    notifyListeners();
  }

  void toggleCollapse() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }
}
