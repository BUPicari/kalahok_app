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
  String passcode = '';
  TextEditingController fieldController = TextEditingController();
  bool correct = false;
  bool clickedSubmit = false;

  @override
  void initState() {
    fieldController.addListener(() {
      setState(() {
        passcode = fieldController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    fieldController.dispose();
    super.dispose();
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
          (clickedSubmit && !correct) ? _errorMessage() : Container(),
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

  Widget _errorMessage() {
    return Column(
      children: [
        Text(
          "Please enter the correct passcode!",
          style: TextStyle(
            color: AppColor.error,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
      ],
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
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          if (correct) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WaiverScreen(
                  survey: widget.survey,
                  addresses: widget.addresses,
                ),
              ),
            );
          } else {
            setState(() {
              clickedSubmit = true;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 40),
          backgroundColor: AppColor.warning,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(Icons.start, color: AppColor.subSecondary),
        label: Text(
          'Submit',
          style: TextStyle(
            color: AppColor.subSecondary,
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
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
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
      style: TextStyle(height: 2.0, color: AppColor.subPrimary),
      onChanged: (value) {
        var cursorPos = fieldController.selection;
        setState(() {
          passcode = value;
          clickedSubmit = false;

          fieldController.text = value;
          if (cursorPos.start > value.length) {
            cursorPos = TextSelection.fromPosition(
              TextPosition(offset: value.length));
          }
          fieldController.selection = cursorPos;
        });

        if (widget.survey.passcode == passcode) {
          setState(() {
            correct = true;
          });
        } else {
          setState(() {
            correct = false;
          });
        }
      },
    );
  }
}
