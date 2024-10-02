import 'package:flutter/material.dart';

import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/initial_screen.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({ Key? key }) : super(key: key);

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  String response = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 250,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColor.linearGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Please enter URL",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: AppColor.warning,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColor.neutral,
                              width: 2.0,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: "URL",
                          fillColor: AppColor.subPrimary,
                          filled: true,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(height: 2.0),
                        onChanged: (value) {
                          setState(() {
                            response = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _updateButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateButton(context) {
    bool condition = response.isNotEmpty ? true : false;
    var btnColor = condition ? AppColor.warning : AppColor.neutral;
    var txtColor = condition ? AppColor.subSecondary : AppColor.secondary;

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: !condition ? null : () {
          ApiConfig.updaterUrl = response;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InitialScreen(),
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
          'UPDATE',
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
