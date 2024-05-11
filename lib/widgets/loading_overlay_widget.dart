import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class LoadingOverlayWidget extends StatelessWidget {
  LoadingOverlayWidget({
    Key? key,
    required this.child,
    required this.progressText,
    this.delay = const Duration(milliseconds: 500),
  }) : _isLoadingNotifier = ValueNotifier(false), super(key: key);

  final ValueNotifier<bool> _isLoadingNotifier;

  final Widget child;
  final String progressText;
  final Duration delay;

  static LoadingOverlayWidget of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<LoadingOverlayWidget>()!;
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
                child: Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(
                    dismissible: false,
                    color: AppColor.subSecondary,
                  ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ElevatedButton(
              onPressed: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 10,
                    color: AppColor.primary,
                    backgroundColor: AppColor.warning,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: Text(
                      progressText,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColor.subPrimary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
