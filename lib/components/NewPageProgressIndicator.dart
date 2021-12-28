import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/src/ui/default_indicators/footer_tile.dart';

// Taken from https://github.com/EdsonBueno/infinite_scroll_pagination/blob/983763669fe7247682cd64f0f8f5d6c6f96d75d3/lib/src/ui/default_indicators/new_page_progress_indicator.dart
// Made CircularProgressIndicator adaptive

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const FooterTile(
        child: CircularProgressIndicator.adaptive(),
      );
}
