import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/online/waiver_screen.dart';

/// CHECKED
class PasscodeWidget extends StatefulWidget {
  late final Surveys survey;
  late final List<String> addresses;

  final ValueNotifier<bool> _isLoadingNotifier;
  final Widget child;
  final String progressText;

  PasscodeWidget({
    Key? key,
    required this.child,
    required this.progressText,
  }) : _isLoadingNotifier = ValueNotifier(false), super(key: key);

  static PasscodeWidget of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<PasscodeWidget>()!;
  }

  void show({ required survey, required addresses }) {
    _isLoadingNotifier.value = true;
    this.survey = survey;
    this.addresses = addresses;
  }

  void hide() {
    _isLoadingNotifier.value = false;
  }

  @override
  State<PasscodeWidget> createState() => _PasscodeWidgetState();
}

/// todo: You can refactor this so that it can be reusable, no need for same code as the local
class _PasscodeWidgetState extends State<PasscodeWidget> {
  late String passcode;
  late TextEditingController fieldController;

  @override
  void initState() {
    super.initState();
    passcode = "";
    fieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: widget._isLoadingNotifier,
        child: widget.child,
        builder: (context, value, child) {
          return Stack(
            children: [
              child!,
              if (value)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(dismissible: false, color: AppColor.subSecondary),
                  ),
                ),
              if (value)
                Center(
                  child: _passcodeTextField(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _passcodeTextField(context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.progressText,
            style: TextStyle(
              color: AppColor.subPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextFieldForms(),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(child: _cancelButton(context)),
              const SizedBox(width: 25),
              Expanded(child: _submitButton(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cancelButton(context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => PasscodeWidget.of(context).hide(),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 40),
          backgroundColor: AppColor.warning,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(
          Icons.arrow_back,
          color: AppColor.subSecondary,
        ),
        label: Text(
          'Cancel',
          style: TextStyle(
            color: AppColor.subSecondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _submitButton(context) {
    bool condition = widget.survey.passcode == passcode ? true : false;
    var btnColor = condition ? AppColor.warning : AppColor.neutral;
    var txtColor = condition ? AppColor.subSecondary : AppColor.secondary;

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: !condition ? null : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaiverScreen(
                survey: widget.survey,
                addresses: widget.addresses,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 40),
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(Icons.start, color: txtColor),
        label: Text(
          'Submit',
          style: TextStyle(
            color: txtColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldForms() {
    return TextField(
      controller: fieldController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.warning,
            width: 2.0,
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: "Passcode",
        hintStyle: TextStyle(color: AppColor.subPrimary),
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(height: 2.0, color: AppColor.subPrimary),
      onChanged: (value) {
        setState(() {
          passcode = value;
        });
      },
    );
  }
}
