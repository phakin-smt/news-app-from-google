import 'package:flutter/material.dart';

class NavButtons extends StatelessWidget {
  const NavButtons({
    super.key,
    required this.canPrev,
    required this.canNext,
    required this.onPrev,
    required this.onNext,
    this.counterText,
  });

  final bool canPrev;
  final bool canNext;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final String? counterText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: canPrev ? onPrev : null,
                label: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: canNext ? onNext : null,
                label: const Text('Next'),
              ),
            ),
          ],
        ),
        if (counterText != null) ...[
          const SizedBox(height: 8),
          Text(counterText!, style: Theme.of(context).textTheme.labelMedium),
        ],
      ],
    );
  }
}
