import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class CustomDropDown extends StatefulWidget {
  List<String> items = [];
  String selectedValue = '';
  Function onchage;

  CustomDropDown({super.key, required this.onchage, required this.items, required this.selectedValue});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<String>(
        value: widget.selectedValue,
        onChanged: (newValue) {
          // widget.selectedValue = newValue!;

          widget.onchage(newValue);

          print('Selected value: ${widget.selectedValue}');
        },
        isExpanded: true,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle()),
          );
        }).toList(),
        underline: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: primaryGreyShade))),
        ),
      ),
    );
  }
}

class CustomDropDownBorder extends StatefulWidget {
  List<String> items = [];
  String? selectedValue;

  String? dropdownTitle;

  String? hintText;

  Function onchage;

  CustomDropDownBorder(
      {super.key,
      required this.onchage,
      required this.items,
      this.hintText,
      required this.selectedValue,
      this.dropdownTitle});

  @override
  State<CustomDropDownBorder> createState() => _CustomDropDownBorderState();
}

class _CustomDropDownBorderState extends State<CustomDropDownBorder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.dropdownTitle ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(width: 0.5, color: skyBlueShade1)),
            child: DropdownButton<String>(
              // style: const TextStyle(color: skyBlueShade3),
              iconEnabledColor: deepBluedark,
              icon: const Icon(Icons.keyboard_arrow_down_outlined, color: primaryBlack),
              value: widget.selectedValue,
              hint: Text(widget.hintText ?? widget.dropdownTitle ?? ""),
              onChanged: (newValue) {
                // widget.selectedValue = newValue!;

                widget.onchage(newValue);

                print('Selected value: ${widget.selectedValue}');
              },
              // iconSize: 40,

              isExpanded: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDownBorderStringDisable extends StatefulWidget {
  List<String> items = [];
  String? selectedValue;

  String? dropdownTitle;

  String? hintText;

  Function onchage;

  CustomDropDownBorderStringDisable(
      {super.key,
      required this.onchage,
      required this.items,
      this.hintText,
      required this.selectedValue,
      this.dropdownTitle});

  @override
  State<CustomDropDownBorderStringDisable> createState() => _CustomDropDownBorderStringDisableState();
}

class _CustomDropDownBorderStringDisableState extends State<CustomDropDownBorderStringDisable> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.dropdownTitle ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(width: 0.5, color: skyBlueShade1)),
            child: DropdownButton<String>(
              /* style: const TextStyle(color: skyBlueShade3),*/
              icon: const Icon(Icons.keyboard_arrow_down_outlined /*,color: primaryBlack,*/),
              value: widget.selectedValue,
              hint: Text(widget.hintText ?? widget.dropdownTitle ?? ""),
              onChanged: null,
              // iconSize: 40,

              isExpanded: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: primaryBlack),
                  ),
                );
              }).toList(),

              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDownBorder1 extends StatefulWidget {
  List<DropdownMenuItem> items;
  var selectedValue;
  bool? isNotEdit = false;
  String? dropdownTitle;

  String? hintText;

  Function onchage;

  CustomDropDownBorder1(
      {super.key,
      this.isNotEdit,
      required this.onchage,
      required this.items,
      this.hintText,
      required this.selectedValue,
      this.dropdownTitle});

  @override
  State<CustomDropDownBorder1> createState() => _CustomDropDownBorder1State();
}

class _CustomDropDownBorder1State extends State<CustomDropDownBorder1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.dropdownTitle ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              if (widget.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                        duration: const Duration(seconds: 2), // SHORT TIME
                        behavior: SnackBarBehavior.fixed,

                        content: AppText(text: noDataAvailable, txtColor: primaryWhite, size: 12)));
                /*
                Fluttertoast.showToast(
                  msg: "No data available",
                  toastLength: Toast.LENGTH_SHORT,
                );*/
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(width: 0.5, color: skyBlueShade1)),
              child: DropdownButton(
                /*style: const TextStyle(color: skyBlueShade3),*/
                iconEnabledColor: deepBluedark,
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: primaryBlack,
                ),
                value: widget.selectedValue,
                hint: Text(widget.hintText ?? widget.dropdownTitle ?? ""),
                onChanged: (newValue) {
                  // widget.selectedValue = newValue!;

                  widget.onchage(newValue);

                  print('Selected value: ${widget.selectedValue}');
                },
                // iconSize: 40,

                isExpanded: true,
                padding: EdgeInsets.only(left: 10, right: 10),
                items: widget.items,
                underline: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDownBorderDisable extends StatefulWidget {
  List<DropdownMenuItem> items;
  var selectedValue;
  bool? isNotEdit = false;
  String? dropdownTitle;
  String? hintText;
  Function onchage;

  CustomDropDownBorderDisable({
    super.key,
    this.isNotEdit,
    required this.onchage,
    required this.items,
    this.hintText,
    required this.selectedValue,
    this.dropdownTitle,
  });

  @override
  State<CustomDropDownBorderDisable> createState() => _CustomDropDownBorderDisableState();
}

class _CustomDropDownBorderDisableState extends State<CustomDropDownBorderDisable> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.dropdownTitle ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),

          /// WRAP WITH InkWell FOR TAP DETECTION
          InkWell(
            onTap: () {
              if (widget.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                        duration: const Duration(seconds: 2), // SHORT TIME
                        behavior: SnackBarBehavior.floating,

                        content: AppText(text: noDataAvailable, txtColor: primaryWhite, size: 12)));
                /*
                Fluttertoast.showToast(
                  msg: "No data available",
                  toastLength: Toast.LENGTH_SHORT,
                );*/
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 0.5, color: skyBlueShade1),
              ),
              child: IgnorePointer(
                ignoring: true, // disable real dropdown completely
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  value: widget.selectedValue,
                  hint: Text(widget.hintText ?? widget.dropdownTitle ?? ""),
                  onChanged: null,
                  // disabled
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  items: widget.items,
                  underline: const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// this is all screens dropdown

/*class CustomDropDownBorderDisable extends StatefulWidget {
  List<DropdownMenuItem> items;
  var selectedValue;
  bool? isNotEdit = false;
  String? dropdownTitle;

  String? hintText;

  Function onchage;

  CustomDropDownBorderDisable({super.key, this.isNotEdit, required this.onchage, required this.items, this.hintText, required this.selectedValue, this.dropdownTitle});

  @override
  State<CustomDropDownBorderDisable> createState() => _CustomDropDownBorderDisableState();
}

class _CustomDropDownBorderDisableState extends State<CustomDropDownBorderDisable> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: widget.dropdownTitle ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(width: 0.5, color: skyBlueShade1)),
            child: DropdownButton(
            */ /*  style: const TextStyle(color: skyBlueShade3),*/ /*
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
              value: widget.selectedValue,
              hint: Text(widget.hintText ?? widget.dropdownTitle ?? ""),
              onChanged: null,
              // iconSize: 40,

              isExpanded: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
              items: widget.items,
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}*/
