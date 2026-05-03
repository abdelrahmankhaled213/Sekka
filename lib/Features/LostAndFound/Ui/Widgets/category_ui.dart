import 'package:flutter/material.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';

class CategoryUI {
  final Category type;
  final String label;
  final IconData icon;

  const CategoryUI(this.type, this.label, this.icon);
}

final List<CategoryUI> categories = const [

  CategoryUI(Category.phone, 'Phone', Icons.phone_android_rounded),
  CategoryUI(Category.wallet, 'Wallet', Icons.account_balance_wallet_outlined),
  CategoryUI(Category.bag, 'Bag/Backpack', Icons.work_outline_rounded),
  CategoryUI(Category.keys, 'Keys', Icons.key_outlined),
  CategoryUI(Category.other, 'Other', Icons.inventory_2_outlined),

];
