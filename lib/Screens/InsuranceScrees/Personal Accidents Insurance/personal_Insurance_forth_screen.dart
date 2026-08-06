import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class PersonalInsuranceForthScreen extends StatefulWidget {
  Function onNext;

  PersonalInsuranceForthScreen({super.key, required this.onNext});

  @override
  State<PersonalInsuranceForthScreen> createState() => _PersonalInsuranceForthScreenState();
}

class _PersonalInsuranceForthScreenState extends State<PersonalInsuranceForthScreen> {
  String _selectedOption = no;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppText(text: lifeq1, size: 15, txtAlign: TextAlign.start),
          ),
          Row(
            children: <Widget>[
              Radio(
                value: yesTxt,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              const Text(yesTxt),
              Radio(
                value: noTxt,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              Text(noTxt),
            ],
          ),
          if (_selectedOption == yesTxt)
            AppText(
              text: lifeerror,
              size: 25,
              txtColor: redShade2,
            ),
          /* InkWell(
            onTap: () {
              if (_selectedOption == 'No')
                widget.onNext();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                buttonImg,
                height: 100,
              ),
            ),
          ),*/
          AppBtnWithColorShades(
            onTap: () {
              if (_selectedOption == noTxt) widget.onNext();
            },
            btnTxt: continuE,
            color1: darkBlue2,
            color2: darkBlue1,
          ),
        ],
      ),
    );
  }
}
