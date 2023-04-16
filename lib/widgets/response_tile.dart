import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';

class ResponseTile extends StatelessWidget {
  const ResponseTile({super.key, this.data, required this.controller});

  final dynamic data;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final type = data["type"].toString();
    final intensity = data["intensity"].toString();
    final intensityEnum = Intensity.values.firstWhere(
      (element) => element.name == intensity,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Text(data["match"]),
        title: Text(
          "Type : ${type[0].toUpperCase() + type.toString().substring(1)}",
        ),
        subtitle: Text(
          "Intensity : ${intensity.toString().toUpperCase()}",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.highlight_alt_rounded),
          onPressed: () {
            controller.selection = TextSelection(
              baseOffset: data["start"],
              extentOffset: data["end"] + 1,
            );
          },
        ),
        tileColor: intensityEnum == Intensity.high
            ? Colors.redAccent[100]
            : intensityEnum == Intensity.low
                ? Colors.yellowAccent[100]
                : Colors.orangeAccent[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
