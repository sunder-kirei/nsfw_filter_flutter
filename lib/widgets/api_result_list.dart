import 'package:flutter/material.dart';

import 'response_tile.dart';

class APIResultList extends StatelessWidget {
  const APIResultList({
    super.key,
    required this.apiResponse,
    required this.controller,
  });

  final List<dynamic> apiResponse;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final data = apiResponse[index];

          return ResponseTile(
            data: data,
            controller: controller,
          );
        },
        childCount: apiResponse.length,
      ),
    );
  }
}
