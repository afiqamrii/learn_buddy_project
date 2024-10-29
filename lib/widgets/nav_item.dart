import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String iconPath;
  final String selectedIconPath;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    required this.iconPath,
    required this.selectedIconPath,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          key: ValueKey<int>(index),
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(20),
              )
                  : null,
              child: Image.asset(
                isSelected ? selectedIconPath : iconPath,
                width: 24,
                height: 24,
                color: isSelected ? Colors.pink : Colors.grey[600],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
