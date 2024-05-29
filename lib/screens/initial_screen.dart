import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import 'package:kalahok_app/screens/online/category_screen.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';
import 'package:kalahok_app/data/models/online/label_model.dart';
import 'package:kalahok_app/data/models/online/dropdown_model.dart';
import 'package:kalahok_app/data/resources/online/dropdown/dropdown_repo.dart';
import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class InitialScreen extends StatefulWidget {
  const InitialScreen({ Key? key }) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late DropdownRepository _dropdownRepository;
  late List<Label> labels;
  List<String> responses = [];
  List<int> filters = [];
  bool isReset = false;

  Future<List<Result>> _getData({
    required path,
    required page,
    required filter,
    required q,
  }) async {
    final list = await _dropdownRepository.getDropdownList(
      path: path,
      page: page,
      filter: filter,
      q: q,
    );

    return list.result;
  }

  @override
  void initState() {
    super.initState();

    _dropdownRepository = DropdownRepository();
    labels = [];

    labels.add(Label(name: "Province", endpoint: "address/paginate/province"));
    labels.add(Label(name: "City", endpoint: "address/paginate/city"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 200,
          left: 16,
          right: 16,
          bottom: 150,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.linearGradient,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please enter your address",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppColor.warning,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(children: labels.asMap().map((index, label)
                => MapEntry(index, Column(children: [
                  SearchableDropdown<Result>.paginated(
                    backgroundDecoration: (child) => Card(
                      margin: EdgeInsets.zero,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColor.neutral,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                    hintText: Text('Select a ${label.name}'),
                    margin: const EdgeInsets.all(15),
                    paginatedRequest: (int page, String? searchKey) async {
                      String f = (index == 0) ? "0" :
                        (index > 0 && filters.isNotEmpty && filters[index-1] != 0) ?
                          filters[index-1].toString() : '';

                      final paginatedList = await _getData(
                        path: '/${label.endpoint}',
                        page: page,
                        filter: f,
                        q: searchKey != null ? searchKey.toString() : '',
                      );

                      return paginatedList.map((e) => SearchableDropdownMenuItem(
                        value: Result(value: e.value, label: e.label),
                        label: e.label,
                        child: Text(e.label),
                      )).toList();
                    },
                    requestItemCount: 10,
                    onChanged: (Result? val) {
                      setState(() {
                        if (index == 0 &&
                          responses.isNotEmpty &&
                          responses[index+1] != '') {
                          isReset = true;
                        } else {
                          isReset = false;
                        }

                        if (index == 0) {
                          filters = [];
                          responses = [];
                        }

                        filters.isNotEmpty ?
                          filters[index] = (val?.value) ?? 0 :
                          filters = List.generate(labels.length, (i) =>
                            i == index ? (val?.value) ?? 0 : 0);

                        responses.isNotEmpty ?
                          responses[index] = (val?.label).toString() :
                          responses = List.generate(labels.length, (i) =>
                            i == index ? (val?.label).toString() : '');
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ]))).values.toList()),
            ),
            isReset ? _errorMessage() : Container(),
            _startButton(context),
          ],
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Responses has been reset, please select new City.",
              style: TextStyle(
                color: AppColor.error,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _startButton(context) {
    bool condition = responses.isNotEmpty ?
      responses[0] != '' && responses[1] != '' ? true : false : false;
    var btnColor = condition ? AppColor.warning : AppColor.neutral;
    var txtColor = condition ? AppColor.subSecondary : AppColor.secondary;

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: !condition ? null : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingOverlayWidget(
                progressText: AppConfig.offlineModeText,
                child: CategoryScreen(addresses: responses),
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
          'START',
          style: TextStyle(
            color: txtColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
