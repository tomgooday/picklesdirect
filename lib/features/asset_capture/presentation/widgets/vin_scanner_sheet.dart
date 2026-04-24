import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';

/// Bottom sheet that activates the device camera for barcode / VIN scanning.
///
/// Returns the scanned string via [Navigator.pop] on first successful decode.
/// Use [showVinScannerSheet] to open and await the result.
class VinScannerSheet extends StatefulWidget {
  const VinScannerSheet({required this.fieldLabel, super.key});

  final String fieldLabel;

  @override
  State<VinScannerSheet> createState() => _VinScannerSheetState();
}

class _VinScannerSheetState extends State<VinScannerSheet> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    _hasScanned = true;
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // ── Handle ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingSm,
            ),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colours.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan ${widget.fieldLabel}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colours.onSurface,
                        ),
                      ),
                      Text(
                        'Point the camera at a barcode or label',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colours.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingSm),

          // ── Camera viewfinder ────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusMd),
              ),
              child: Stack(
                children: [
                  MobileScanner(controller: _controller, onDetect: _onDetect),
                  // Targeting overlay
                  Center(
                    child: Container(
                      width: 280,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm,
                        ),
                      ),
                    ),
                  ),
                  // Torch toggle
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: _TorchToggle(controller: _controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TorchToggle extends StatefulWidget {
  const _TorchToggle({required this.controller});
  final MobileScannerController controller;

  @override
  State<_TorchToggle> createState() => _TorchToggleState();
}

class _TorchToggleState extends State<_TorchToggle> {
  bool _torchOn = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'torch',
      onPressed: () {
        widget.controller.toggleTorch();
        setState(() => _torchOn = !_torchOn);
      },
      child: Icon(_torchOn ? Icons.flash_off : Icons.flash_on),
    );
  }
}

/// Convenience function to open the VIN scanner sheet and return the result.
///
/// Returns `null` if the user dismissed without scanning.
Future<String?> showVinScannerSheet(
  BuildContext context, {
  required String fieldLabel,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark.surface
        : AppColours.light.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    ),
    builder: (_) => VinScannerSheet(fieldLabel: fieldLabel),
  );
}
