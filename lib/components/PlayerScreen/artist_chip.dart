import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/jellyfin_models.dart';
import '../album_image.dart';

class ArtistChip extends StatelessWidget {
  const ArtistChip({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BaseItemDto item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Material(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: BareAlbumImage(item: item),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                child: Text(
                    item.albumArtist ??
                        AppLocalizations.of(context)!.unknownArtist,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 12,
                      height: 15 / 12,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
