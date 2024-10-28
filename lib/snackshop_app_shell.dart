import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SnackshopAppShell extends StatefulWidget {
  const SnackshopAppShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  final Widget child;
  final int currentIndex;

  @override
  State<SnackshopAppShell> createState() => _SnackshopAppShellState();
}

class _SnackshopAppShellState extends State<SnackshopAppShell> {
  void _onItemTapped(int index, BuildContext context) {
    if (index == 1) {
      GoRouter.of(context).go("/menu");
    } else if (index == 2) {
      GoRouter.of(context).go("/cart");
    } else if (index == 3) {
      GoRouter.of(context).go("/settings");
    } else {
      GoRouter.of(context).go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (int idx) => _onItemTapped(idx, context),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
            ),
            label: "홈",
          ),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: "메뉴"),
          BottomNavigationBarItem(
              icon: Icon(
                widget.currentIndex == 2
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: "카트"),
          BottomNavigationBarItem(
              icon: Icon(
                widget.currentIndex == 3
                    ? Icons.person
                    : Icons.person_2_outlined,
              ),
              label: "세팅"),
        ],
      ),
    );
  }
}
