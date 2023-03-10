import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';

class ChoiceWidget extends StatelessWidget {
  final Questions question;
  // final ValueChanged<Choice> onClickedChoice;
  // final ValueChanged<String> onAddOthers;

  const ChoiceWidget({
    Key? key,
    required this.question,
    // required this.onClickedChoice,
    // required this.onAddOthers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: Utils.heightBetween(
        _buildListViewChildren(),
        height: 8,
      ),
    );
  }

  List<Widget> _buildListViewChildren() {
    var children = <Widget>[];

    children = question.choices
        .map((choice) => _buildChoiceContainer(choice))
        .toList();

    if (question.config.canAddOthers) {
      children.add(_buildAddOthers());
    }

    return children;
  }

  Widget _buildChoiceContainer(Choice choice) {
    final containerColor = question.config.multipleAnswer
        ? _getColorForChoices(choice)
        : _getColorForChoice(choice);

    return GestureDetector(
      // onTap: () => onClickedChoice(choice),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColor.neutral,
              width: 2.0
          ),
        ),
        child: Column(
          children: [
            _buildChoice(choice),
          ],
        ),
      ),
    );
  }

  Widget _buildChoice(Choice choice) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Text(
              choice.name,
              style: TextStyle(
                fontSize: 20,
                color: AppColor.subSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOthers() {
    String subText = question.type == 'trueOrFalse'
        ? 'If Yes/No or True/False, please specify'
        : 'If others, please specify';

    return TextField(
      // onChanged: (value) => onAddOthers(value),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: AppColor.neutral,
              width: 2.0
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: subText,
      ),
      style: const TextStyle(height: 2.0),
    );
  }

  Color _getColorForChoice(Choice choice) {
    // final isSelected = choice == question.selectedChoice;
    //
    // if (!isSelected) {
    //   return AppColor.subPrimary;
    // } else {
    //   return AppColor.warning;
    // }

    return AppColor.subPrimary;
  }

  Color _getColorForChoices(Choice choice) {
    // final isSelected = question.selectedChoices?.contains(choice) ?? false;
    //
    // if (!isSelected) {
    //   return AppColor.subPrimary;
    // } else {
    //   return AppColor.warning;
    // }

    return AppColor.subPrimary;
  }
}
