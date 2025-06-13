import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class HapticFeedbackManager extends ChangeNotifier {
  factory HapticFeedbackManager() => _instance;
  HapticFeedbackManager._internal();
  static final HapticFeedbackManager _instance = HapticFeedbackManager._internal();

  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    if (_isEnabled != value) {
      _isEnabled = value;
      notifyListeners();
    }
  }

  void toggle() => isEnabled = !isEnabled;

  void lightImpact() {
    if (_isEnabled) {
      HapticFeedback.lightImpact();
    } else {
      _hapticsAreDisabledLog();
    }
  }

  void mediumImpact() {
    if (_isEnabled) {
      HapticFeedback.mediumImpact();
    } else {
      _hapticsAreDisabledLog();
    }
  }

  void heavyImpact() {
    if (_isEnabled) {
      HapticFeedback.heavyImpact();
    } else {
      _hapticsAreDisabledLog();
    }
  }

  void selectionClick() {
    if (_isEnabled) {
      HapticFeedback.selectionClick();
    } else {
      _hapticsAreDisabledLog();
    }
  }

  void vibrate() {
    if (_isEnabled) {
      HapticFeedback.vibrate();
    } else {
      _hapticsAreDisabledLog();
    }
  }

  void _hapticsAreDisabledLog() => log('Haptics are disabled so not triggering vibration');
}

enum HapticFeedbackType { light, medium, heavy, selectionClick, vibrate }

final class HapticButton extends StatelessWidget {
  const HapticButton({
    required this.child,
    this.type = HapticFeedbackType.selectionClick,
    this.onTap,
    this.color,
    super.key,
  });

  final Widget child;
  final void Function()? onTap;
  final HapticFeedbackType type;
  final Color? color;

  static final HapticFeedbackManager _haptic = HapticFeedbackManager();

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      onTap?.call();

      return switch (type) {
        HapticFeedbackType.light => _haptic.lightImpact(),
        HapticFeedbackType.medium => _haptic.mediumImpact(),
        HapticFeedbackType.heavy => _haptic.heavyImpact(),
        HapticFeedbackType.selectionClick => _haptic.selectionClick(),
        HapticFeedbackType.vibrate => _haptic.vibrate(),
      };
    },
    child: ColoredBox(color: color ?? Colors.transparent, child: child),
  );
}
