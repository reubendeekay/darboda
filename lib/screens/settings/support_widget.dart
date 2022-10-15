import 'package:darboda/constants.dart';
import 'package:darboda/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class SupportWidget extends StatelessWidget {
  const SupportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            'Help and Support',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              'Inform us of any query you have and a customer care representative will get back to you shortly',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextFormField(
            maxLength: null,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter your query',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              border: outlineBorder,
              focusedBorder: focusedBorder,
              enabledBorder: outlineBorder,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: PrimaryButton(
              text: 'Submit',
              onTap: () {
                Navigator.of(context).pop();
              }),
        ),
        const SizedBox(
          height: 5,
        ),
      ]),
    );
  }
}
