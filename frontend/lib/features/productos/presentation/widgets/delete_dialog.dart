import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

/// Diálogo de confirmación para eliminar un producto.
class DeleteDialog extends StatelessWidget {
  final String productName;
  final VoidCallback onConfirm;

  const DeleteDialog({
    super.key,
    required this.productName,
    required this.onConfirm,
  });

  /// Muestra el diálogo de confirmación.
  static Future<bool?> show(
    BuildContext context, {
    required String productName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialog(
        productName: productName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor),
          SizedBox(width: 8),
          Text('Confirmar eliminación'),
        ],
      ),
      content: Text(
        '${AppConstants.eliminarConfirmacion}\n\n"$productName"',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppConstants.cancelarButton),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.errorColor,
            foregroundColor: Colors.white,
          ),
          child: const Text(AppConstants.eliminarButton),
        ),
      ],
    );
  }
}