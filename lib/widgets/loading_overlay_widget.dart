import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class LoadingOverlay extends StatelessWidget {
  LoadingOverlay({
    Key? key,
    required this.child,
    required this.progressText,
    this.delay = const Duration(milliseconds: 500),
  }) : _isLoadingNotifier = ValueNotifier(false), super(key: key);

  final ValueNotifier<bool> _isLoadingNotifier;

  final Widget child;
  final String progressText;
  final Duration delay;

  static LoadingOverlay of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<LoadingOverlay>()!;
  }

  void show() {
    _isLoadingNotifier.value = true;
  }

  void hide() {
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      child: child,
      builder: (context, value, child) {
        return Stack(
          children: [
            child!,
            if (value)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              ),
            if (value)
              Center(
                child: FutureBuilder(
                  future: Future.delayed(delay),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done ?
                      _getProgressIndicator(context) :
                      const SizedBox();
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _getProgressIndicator(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ElevatedButton(
              onPressed: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: AppColor.subPrimary,
                  ),
                  Text(
                    progressText,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]),
    );
  }
}
