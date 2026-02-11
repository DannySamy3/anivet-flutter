import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_bottom_nav.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        // Navigate to home/feed
        break;
      case 1:
        // Navigate to pets
        break;
      case 2:
        // Navigate to store/products
        break;
      case 3:
        // Navigate to feed
        break;
      case 4:
        // Navigate to settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: widget.currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
