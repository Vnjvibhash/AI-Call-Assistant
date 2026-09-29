import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.showDot = true,
  });

  factory StatusBadge.priority(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = AppTheme.accentRed;
        break;
      case 'high':
        color = AppTheme.accentRose;
        break;
      case 'medium':
        color = AppTheme.accentAmber;
        break;
      case 'low':
      default:
        color = AppTheme.accentEmerald;
        break;
    }
    return StatusBadge(
      label: priority.toUpperCase(),
      color: color,
    );
  }

  factory StatusBadge.mode(String mode) {
    final isLocal = mode.toLowerCase() == 'local';
    return StatusBadge(
      label: isLocal ? 'LOCAL MODE (PRIVATE)' : 'CLOUD (GEMINI)',
      color: isLocal ? AppTheme.accentEmerald : AppTheme.primaryBlue,
      icon: isLocal ? Icons.security_rounded : Icons.cloud_outlined,
      showDot: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
