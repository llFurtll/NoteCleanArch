import 'package:flutter/material.dart';

class AlterName extends StatelessWidget {

  final String? userName;

  AlterName({required this.userName});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          height: 80.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextFormField(
                    initialValue: userName,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: const BorderSide(
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Salvar", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}