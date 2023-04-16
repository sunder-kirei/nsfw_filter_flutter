import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../widgets/api_result_list.dart';

class TextFilter extends StatefulWidget {
  const TextFilter({super.key});

  @override
  State<TextFilter> createState() => _TextFilterState();
}

class _TextFilterState extends State<TextFilter> {
  final controller = TextEditingController();
  bool isLoading = false;
  List<dynamic> apiResponse = [];
  Timer? _debouce;

  void checkProfanity() async {
    setState(() {
      isLoading = true;
    });
    final response = await APIHelper.checkProfanity(
      text: controller.value.text,
    );
    setState(() {
      isLoading = false;
      apiResponse = response;
    });
  }

  void _onChangeHandler(String query) {
    if (_debouce?.isActive ?? false) _debouce?.cancel();

    _debouce = Timer(const Duration(milliseconds: 300), () {
      checkProfanity();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _debouce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
              top: 40,
            ),
            child: TextField(
              controller: controller,
              onEditingComplete: checkProfanity,
              onChanged: _onChangeHandler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                suffixIconColor: Theme.of(context).colorScheme.primary,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: isLoading ? null : checkProfanity,
              child: isLoading
                  ? const Text("Checking...")
                  : const Text("Check Profanity"),
            ),
          ),
        ),
        if (apiResponse.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                "Everything looks good!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        if (isLoading)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (apiResponse.isNotEmpty)
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        if (!isLoading)
          APIResultList(
            apiResponse: apiResponse,
            controller: controller,
          ),
      ],
    );
  }
}
