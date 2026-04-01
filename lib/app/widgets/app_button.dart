import 'package:flutter/material.dart';

import '../app_theme.dart';

enum _AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = false,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton._({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    required _AppButtonVariant variant,
    this.isExpanded = false,
  }) : _variant = variant;

  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    bool isExpanded = false,
  }) {
    return AppButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      icon: icon,
      variant: _AppButtonVariant.primary,
      isExpanded: isExpanded,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    bool isExpanded = false,
  }) {
    return AppButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      icon: icon,
      variant: _AppButtonVariant.secondary,
      isExpanded: isExpanded,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final _AppButtonVariant _variant;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final button = switch (_variant) {
      _AppButtonVariant.primary => _buildPrimaryButton(),
      _AppButtonVariant.secondary => _buildSecondaryButton(),
    };

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildPrimaryButton() {
    final style = FilledButton.styleFrom(
      backgroundColor: AppTheme.primary,
      foregroundColor: AppTheme.appBg,
      disabledBackgroundColor: AppTheme.primary.withOpacity(0.4),
      disabledForegroundColor: AppTheme.appBg.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      padding: EdgeInsets.zero,
    );

    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: icon!,
      label: Text(label),
    );
  }

  Widget _buildSecondaryButton() {
    final style = OutlinedButton.styleFrom(
      foregroundColor: AppTheme.secondary,
      disabledForegroundColor: AppTheme.secondary.withOpacity(0.6),
      side: const BorderSide(color: AppTheme.secondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: AppTheme.spacing3,
      ),
    );

    if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: icon!,
      label: Text(label),
    );
  }
}
