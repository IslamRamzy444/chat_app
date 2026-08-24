import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryEntity {
  final String id;
  final String nameKey;
  final IconData iconData;
  CategoryEntity({
    required this.id,
    required this.nameKey,
    required this.iconData,
  });
  String getLocalizedName(BuildContext context) {
    switch (nameKey) {
      case 'sports':
        return AppLocalizations.of(context)!.sports;
      case 'movies':
        return AppLocalizations.of(context)!.movies;
      case 'music':
        return AppLocalizations.of(context)!.music;
      case 'technology':
        return AppLocalizations.of(context)!.technology;
      case 'science':
        return AppLocalizations.of(context)!.science;
      case 'literature':
        return AppLocalizations.of(context)!.literature;
      case 'gaming':
        return AppLocalizations.of(context)!.gaming;
      case 'travel':
        return AppLocalizations.of(context)!.travel;
      case 'food':
        return AppLocalizations.of(context)!.food;
      default:
        return nameKey;
    }
  }

  static List<CategoryEntity> categories = [
    CategoryEntity(
      id: 'sports',
      nameKey: 'sports',
      iconData: Icons.sports_soccer_sharp,
    ),
    CategoryEntity(id: 'movies', nameKey: 'movies', iconData: Icons.movie),
    CategoryEntity(id: 'music', nameKey: 'music', iconData: Icons.music_note),
    CategoryEntity(
      id: 'technology',
      nameKey: 'technology',
      iconData: Icons.computer,
    ),
    CategoryEntity(id: 'science', nameKey: 'science', iconData: Icons.science),
    CategoryEntity(
      id: 'literature',
      nameKey: 'literature',
      iconData: Icons.library_books,
    ),
    CategoryEntity(
      id: 'gaming',
      nameKey: 'gaming',
      iconData: Icons.sports_esports,
    ),
    CategoryEntity(id: 'travel', nameKey: 'travel', iconData: Icons.flight),
    CategoryEntity(id: 'food', nameKey: 'food', iconData: Icons.restaurant),
  ];
  static CategoryEntity? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
