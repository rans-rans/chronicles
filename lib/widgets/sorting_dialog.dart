// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/settings_page.dart';
import '../providers/app_settings.dart';

class SortingDialog extends StatelessWidget {
  SortingOrder sortingOrder;
  SortingDialog(this.sortingOrder, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () async => await Provider.of<AppSettings>(
            context,
            listen: false,
          ).toggleSortingOrder(sortingOrder).then(
                (_) => Navigator.of(context).pop(),
              ),
        ),
      ],
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Radio(
                    value: SortingOrder.titleAscending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Title ascending")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: SortingOrder.titleDescending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Title descending")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: SortingOrder.dateCreatedAscending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Date-created Ascending")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: SortingOrder.dateCreatedDescending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Date-created Descending")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: SortingOrder.dateModifiedAscending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Date-modified Ascending")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: SortingOrder.dateModifiedDescending,
                    groupValue: sortingOrder,
                    onChanged: (value) => setState(() => sortingOrder = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text("Date-modified Descending")
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
