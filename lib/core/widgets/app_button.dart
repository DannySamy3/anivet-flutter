import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
  });

  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) =>
      AppButton(
        key: key,
        text: text,
        onPressed: onPressed,
        isLoading: isLoading,
        type: ButtonType.primary,
        icon: icon,
        width: width,
      );

  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) =>
      AppButton(
        key: key,
        text: text,
        onPressed: onPressed,
        isLoading: isLoading,
        type: ButtonType.secondary,
        icon: icon,
        width: width,
      );

  factory AppButton.outline({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Key? key,
  }) =>
      AppButton(
        key: key,
        text: text,
        onPressed: onPressed,
        isLoading: isLoading,
        type: ButtonType.outline,
        icon: icon,
        width: width,
      );

  @override
  Widget build(BuildContext context) {
    final button = switch (type) {
      ButtonType.primary => _buildPrimaryButton(context),
      ButtonType.secondary => _buildSecondaryButton(context),
      ButtonType.outline => _buildOutlineButton(context),
    };

    return SizedBox(width: width ?? double.infinity, child: button);
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.5),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildOutlineButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      );
    }

    return Text(text);
  }
}

enum ButtonType { primary, secondary, outline }
