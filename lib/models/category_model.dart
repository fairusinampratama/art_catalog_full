import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel(
      {required this.name, required this.iconPath, required this.boxColor});

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'Germany',
        iconPath: 'assets/icons/germany.png',
        boxColor: const Color(0xFFF0A500)));

    categories.add(CategoryModel(
        name: 'France',
        iconPath: 'assets/icons/france.png',
        boxColor: const Color(0xFFCF7500)));

    categories.add(CategoryModel(
        name: 'Spain',
        iconPath: 'assets/icons/spain.png',
        boxColor: const Color(0xFFF0A500)));

    categories.add(CategoryModel(
        name: 'Netherlands',
        iconPath: 'assets/icons/netherlands.png',
        boxColor: const Color(0xFFF0A500)));

    categories.add(CategoryModel(
        name: 'United States',
        iconPath: 'assets/icons/united-states.png',
        boxColor: const Color(0xFFCF7500)));
    return categories;
  }
}
