import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:infinite_scroll_pagination/src/widgets/helpers/default_status_indicators/footer_tile.dart';

// Taken from https://github.com/EdsonBueno/infinite_scroll_pagination/blob/e1a826d5a06d8cfb6c2146658d59465ced4140cd/lib/src/widgets/helpers/default_status_indicators/new_page_progress_indicator.dart
// Made CircularProgressIndicator adaptive

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const FooterTile(
        child: CircularProgressIndicator.adaptive(),
      );
}
