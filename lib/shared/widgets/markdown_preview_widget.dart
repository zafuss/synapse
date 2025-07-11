import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownPreviewWidget extends StatelessWidget {
  final String text;
  final bool isMarkdown;

  const MarkdownPreviewWidget({
    super.key,
    required this.text,
    this.isMarkdown = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isMarkdown) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: MarkdownWidget(data: text),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: SelectableText(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      );
    }
  }
}
