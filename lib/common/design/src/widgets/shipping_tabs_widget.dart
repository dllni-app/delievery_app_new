import 'package:flutter/material.dart';
import '../../../extensions/src/context_extensions.dart';
import '../../../helper/src/locale_keys.dart';

class ShippingTabs extends StatelessWidget {

  final ValueNotifier<SearchType> selectedIndex;

  const ShippingTabs({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final primary = context.primarySwatch;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildTab(
            title:  LocaleKeys.searchSea.tr(),
            uniteValue: SearchType.sea,
            selectedIndex:selectedIndex,
            primary: primary,
          ),
          _buildTab(
            title:  LocaleKeys.searchAir.tr(),
            uniteValue: SearchType.air,
            selectedIndex:selectedIndex,
            primary: primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required SearchType uniteValue,
    required ValueNotifier<SearchType> selectedIndex,
    required Color primary,
  }) {


    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return GestureDetector(
            onTap: ()=>selectedIndex.value=uniteValue,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: value==uniteValue ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  title,
                  style:context.bodyLarge(
                    color: value==uniteValue ? Colors.white : primary,
                    fontSize: 14

                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

enum SearchType{sea ,air}