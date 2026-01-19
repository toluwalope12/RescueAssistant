//  lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback onMicTap;
  final VoidCallback onHistoryTap;
  final bool isRecording;
  final AnimationController? micAnimationController;

  const BottomNavBar({
  super.key,
  required this.onMicTap,
  required this.onHistoryTap,
  required this.isRecording,
  this.micAnimationController,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, -2),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // History button
          IconButton(
            onPressed: onHistoryTap,
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: "View History",
            iconSize: 32,
          ),

          // Mic button with scale animation
          GestureDetector(
            onTap: onMicTap,
            child: AnimatedBuilder(
              animation: micAnimationController ?? kAlwaysCompleteAnimation,
              builder: (context, child) {
                final scale = isRecording
                    ? micAnimationController?.value ?? 1.0
                    : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? Colors.redAccent : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      Icons.mic,
                      color: isRecording ? Colors.white : Colors.red[800],
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),

          // Placeholder for future button (optional)
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

const kAlwaysCompleteAnimation =
    AlwaysStoppedAnimation<double>(1.0); // fallback for AnimatedBuilder
