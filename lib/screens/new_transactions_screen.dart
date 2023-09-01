import 'dart:math';

import 'package:financial/constant.dart';
import 'package:financial/main.dart';
import 'package:financial/models/money.dart';
import 'package:financial/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:financial/utils/extension.dart';

class NewTransactionsScreen extends StatefulWidget {
  const NewTransactionsScreen({super.key});
  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = 'تاریخ';
  @override
  State<NewTransactionsScreen> createState() => _NewTransactionsScreenState();
}

class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  Box hiveBox = Hive.box('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:  Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                   Text(NewTransactionsScreen.isEditing ? 'ویرایش تراکنش' : 'تراکنش جدید',
                   style:  TextStyle(fontSize: ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.015,),),
                   MyTextField(controller: NewTransactionsScreen.descriptionController,hintText: "توضیحات", type: TextInputType.text,),
                   MyTextField(controller: NewTransactionsScreen.priceController,hintText: 'مبلغ',type: TextInputType.number,),
                   const SizedBox(height: 20,),
                   const TypeAndDateWidget(),
                   const SizedBox(height: 20,),
                    MyButton(text : NewTransactionsScreen.isEditing ? 'ویرایش کردن' : 'اضافه کردن',
                    onPressed: () {
                      Money item = Money(
                      id: Random().nextInt(99999999),
                      price: NewTransactionsScreen.priceController.text,
                      title: NewTransactionsScreen.descriptionController.text,
                      date: NewTransactionsScreen.date,
                      isReceived: NewTransactionsScreen.groupId == 1 ? true : false,
                      );
                    if(NewTransactionsScreen.isEditing){
                      int index = 0;
                      MyApp.getData();
                      for (int i = 0; i < hiveBox.values.length; i++) {
                        if (hiveBox.values.elementAt(i).id == NewTransactionsScreen.id) {
                          index = i;
                        }
                      }
                      print(index);
                     hiveBox.putAt(index, item);
                    }else{
                      HomeScreen.moneys.add(item);
                      hiveBox.add(item);
                    }
                      Navigator.pop(context);
                  },),
                ],
          ),
        ),
      ),
    );
  }
}

//! My Button
class MyButton extends StatefulWidget {
  final String text;
  final Function() onPressed;

  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: KPurpleColor,
          elevation: 0,
        ),
        onPressed: widget.onPressed,
        child: Text(widget.text),),);
  }
}
//! Type And Date Widget
class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({
    super.key,
  });

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButton(
          value: 1,
          groupValue: NewTransactionsScreen.groupId,
          onChanged: (value) {
            setState(() {
              NewTransactionsScreen.groupId = value!;
            });
          }, text:'دریافتی',),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: MyRadioButton(
          value: 2,
          groupValue: NewTransactionsScreen.groupId,
          onChanged: (value) {
            setState(() {
              NewTransactionsScreen.groupId = value!;
            });
          }, text: 'پرداختی',),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(onPressed: ()async{
              var pickedDate = await showPersianDatePicker(
                context: context,
                initialDate: Jalali.now(),
                firstDate: Jalali(1400),
                lastDate: Jalali(1499),);
                setState(() {
                  String year = pickedDate!.year.toString();
                  String month = pickedDate.month.toString().length == 1 ? '0${pickedDate.month.toString()}' : pickedDate.month.toString();
                  String day = pickedDate.day.toString().length == 1 ? '0${pickedDate.day.toString()}' : pickedDate.day.toString();
                  NewTransactionsScreen.date = year + '/' + month + '/' + day;
                });
            },
            child: Text(
              NewTransactionsScreen.date,
              style: TextStyle(color: Colors.black, fontSize: ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.01,),),),
          ),
        ),
    
    ],);
  }
}
//! My Radio Button
class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text});
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
          Expanded(child: Radio(value: value, groupValue: groupValue, onChanged: onChanged)),
          Text(text,style:TextStyle(fontSize: ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.01,),),
    ],);
  }
}
//! My TextField
class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextField({super.key,required this.controller ,required this.hintText , required this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      decoration: InputDecoration(border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300),),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: ScreenSize(context).screenWidth < 1004 ? 12.0 : ScreenSize(context).screenWidth * 0.015,),
      ),
      
    );
  }
}