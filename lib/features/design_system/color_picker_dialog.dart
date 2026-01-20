import 'package:flutter/material.dart';

/// Simple color picker dialog for selecting colors.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.initialColor,
    super.key,
  });

  final Color initialColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColor;

  // Predefined color swatches
  static const List<Color> _swatches = [
    // Grays
    Color(0xFF000000),
    Color(0xFF374151),
    Color(0xFF6B7280),
    Color(0xFF9CA3AF),
    Color(0xFFD1D5DB),
    Color(0xFFF3F4F6),
    Color(0xFFFFFFFF),

    // Reds
    Color(0xFFDC2626),
    Color(0xFFEF4444),
    Color(0xFFF87171),
    Color(0xFFFCA5A5),

    // Oranges
    Color(0xFFEA580C),
    Color(0xFFF97316),
    Color(0xFFFB923C),
    Color(0xFFFDBA74),

    // Yellows
    Color(0xFFCA8A04),
    Color(0xFFEAB308),
    Color(0xFFFACC15),
    Color(0xFFFDE047),

    // Greens
    Color(0xFF16A34A),
    Color(0xFF22C55E),
    Color(0xFF4ADE80),
    Color(0xFF86EFAC),

    // Teals
    Color(0xFF0D9488),
    Color(0xFF14B8A6),
    Color(0xFF2DD4BF),
    Color(0xFF5EEAD4),

    // Blues
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
    Color(0xFF93C5FD),

    // Indigos
    Color(0xFF4F46E5),
    Color(0xFF6366F1),
    Color(0xFF818CF8),
    Color(0xFFA5B4FC),

    // Purples
    Color(0xFF9333EA),
    Color(0xFFA855F7),
    Color(0xFFC084FC),
    Color(0xFFD8B4FE),

    // Pinks
    Color(0xFFDB2777),
    Color(0xFFEC4899),
    Color(0xFFF472B6),
    Color(0xFFF9A8D4),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final hexValue = _selectedColor
        .toARGB32()
        .toRadixString(16)
        .toUpperCase()
        .padLeft(8, '0');

    return AlertDialog(
      title: const Text('Select Color'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected color preview
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '#$hexValue',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            // Color swatches
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _swatches.map((color) {
                final isSelected =
                    color.toARGB32() == _selectedColor.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: _getContrastColor(color),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedColor),
          child: const Text('Select'),
        ),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    // Simple contrast calculation
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
