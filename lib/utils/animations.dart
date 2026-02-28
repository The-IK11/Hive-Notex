import 'package:flutter/material.dart';

/// Animation helper class to manage all animation controllers and animations
class NotePadAnimations {
  late AnimationController fabController;
  late AnimationController listController;
  late Animation<double> fabScale;
  late Animation<double> fabRotation;

  /// Initialize all animations
  void initializeAnimations(TickerProvider vsync) {
    fabController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );

    listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    fabScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: fabController, curve: Curves.elasticOut),
    );

    fabRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: fabController, curve: Curves.easeInOut),
    );
  }

  /// Start all animations
  void startAnimations() {
    fabController.forward();
    listController.forward();
  }

  /// Dispose all animation controllers
  void dispose() {
    fabController.dispose();
    listController.dispose();
  }

  /// Get the animation for note card slide-in
  Animation<Offset> getListItemAnimation(int index, int totalItems) {
    return Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: listController,
        curve: Interval(
          (index / totalItems * 0.5).clamp(0, 1),
          ((index + 1) / totalItems * 0.5).clamp(0, 1),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
