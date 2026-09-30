import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class FluidNavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const FluidNavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class FluidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FluidNavBarItem>? items;

  const FluidGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  static const List<FluidNavBarItem> defaultItems = [
    FluidNavBarItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Home',
    ),
    FluidNavBarItem(
      icon: Icons.call_outlined,
      activeIcon: Icons.call_rounded,
      label: 'Calls',
    ),
    FluidNavBarItem(
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
      label: 'AI Chat',
    ),
    FluidNavBarItem(
      icon: Icons.alarm_outlined,
      activeIcon: Icons.alarm_rounded,
      label: 'Reminders',
    ),
    FluidNavBarItem(
      icon: Icons.tune_outlined,
      activeIcon: Icons.tune_rounded,
      label: 'Settings',
    ),
  ];

  @override
  State<FluidGlassNavBar> createState() => _FluidGlassNavBarState();
}

class _FluidGlassNavBarState extends State<FluidGlassNavBar> with SingleTickerProviderStateMixin {
  late final List<FluidNavBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = widget.items ?? FluidGlassNavBar.defaultItems;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: bottomInset > 0 ? bottomInset + 4 : 14,
      ),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            // Ambient neon cyan/blue glow
            BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.24),
              blurRadius: 30,
              spreadRadius: -2,
              offset: const Offset(0, 10),
            ),
            // Deep contrast shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.65),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                // Frosted fluid glass gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0F172A).withValues(alpha: 0.82),
                    const Color(0xFF1E293B).withValues(alpha: 0.68),
                    const Color(0xFF090D16).withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                  width: 1.2,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const horizontalPadding = 6.0;
                  final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
                  final itemWidth = availableWidth / _navItems.length;
                  final activeLeft = horizontalPadding + (widget.currentIndex * itemWidth);

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Subtly illuminated top glass sheen edge
                      Positioned(
                        top: 0,
                        left: 20,
                        right: 20,
                        height: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.35),
                                AppTheme.accentCyan.withValues(alpha: 0.4),
                                Colors.white.withValues(alpha: 0.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Fluid Moving Indicator Pill
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        left: activeLeft,
                        width: itemWidth,
                        top: 6,
                        bottom: 6,
                        child: _buildMovingFluidPill(),
                      ),

                      // Row of interactive tab items
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row(
                          children: List.generate(_navItems.length, (index) {
                            return Expanded(
                              child: _buildTabItem(index),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovingFluidPill() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.accentCyan,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          // Dynamic illuminated neon aura
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.55),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: AppTheme.accentCyan.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index) {
    final item = _navItems[index];
    final isSelected = widget.currentIndex == index;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.currentIndex != index) {
              HapticFeedback.selectionClick();
              widget.onTap(index);
            }
          },
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 0.92,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                    size: 21,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  style: GoogleFonts.outfit(
                    fontSize: isSelected ? 11 : 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF64748B),
                    letterSpacing: isSelected ? 0.3 : 0,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
