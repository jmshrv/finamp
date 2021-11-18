import '../models/JellyfinModels.dart';

/// Checks if the item has its own image (not inherited from a parent)
bool itemHasOwnImage(BaseItemDto item) =>
    item.imageTags?.containsKey("Primary") ?? false;
