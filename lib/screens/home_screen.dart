// ignore_for_file: must_be_immutable

import 'package:financial/constant.dart';
import 'package:financial/main.dart';
import 'package:financial/models/money.dart';
import 'package:financial/screens/new_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:financial/utils/extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box hiveBox = Hive.box('moneyBox');
  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              headerWidget(),
              //const Expanded(child: EmptyWidget()),
              Expanded(
                child: HomeScreen.moneys.isEmpty ? const EmptyWidget() : ListView.builder(
                  itemCount: HomeScreen.moneys.length,
                  itemBuilder: (context,index){
                  return  GestureDetector(
                    //* Edit
                    onTap: (){
                      NewTransactionsScreen.date = HomeScreen.moneys[index].date;
                      NewTransactionsScreen.descriptionController.text = HomeScreen.moneys[index].title;
                      NewTransactionsScreen.priceController.text = HomeScreen.moneys[index].price;
                      NewTransactionsScreen.groupId = HomeScreen.moneys[index].isReceived ? 1 : 2;
                      NewTransactionsScreen.isEditing = true;
                      NewTransactionsScreen.id = HomeScreen.moneys[index].id;
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> const NewTransactionsScreen(),),
                      ).then((value){
                        MyApp.getData();
                        setState(() {});
                        });
                    },

                    //! Delete
                    onLongPress: () {
                      showDialog(context: context, builder: (context)=> AlertDialog(
                        title: const Text("آیا از حذف این آیتم مطمئن هستید؟", style: TextStyle(fontSize: 12.0),),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('خیر',style: TextStyle(color: Colors.black87),),),
                          TextButton(onPressed: (){
                            hiveBox.deleteAt(index);
                            MyApp.getData();
                            setState(() {
                              //HomeScreen.moneys.removeAt(index);

                            });
                            Navigator.pop(context);
                          }, child: const Text('بله',style: TextStyle(color: Colors.black87),),),
                        ],
                      ),);
                    },
                    child: MyListTileWidget(index: index));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //! Fab Widget
  Widget fabWidget(){
    return FloatingActionButton(onPressed: (){
      NewTransactionsScreen.date = 'تاریخ';
      NewTransactionsScreen.descriptionController.text = '';
      NewTransactionsScreen.priceController.text = '';
      NewTransactionsScreen.groupId = 0;
      NewTransactionsScreen.isEditing = false;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NewTransactionsScreen(),
      ),).then((value) => {
        MyApp.getData(),
       setState((){
        print('Refresh');
       }),
      });
    },
    backgroundColor: KPurpleColor,
    elevation: 0,
    child: const Icon(Icons.add) ,);
  }
  //! Header Widget
 Widget headerWidget(){
  return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(children: [
      Expanded(
        child: SearchBarAnimation(
        textEditingController: searchController,
        isOriginalAnimation: false,
        hintText: '...جستجو کنید',
        buttonElevation: 0,
        buttonShadowColour: Colors.black26,
        buttonBorderColour: Colors.black26,
        buttonWidget: const Icon(Icons.search),
        secondaryButtonWidget: const Icon(Icons.close),
        trailingWidget: const Icon(Icons.search) ,
        onFieldSubmitted: (String text){
          List result = hiveBox.values.where((value) => value.title.contains(text) || value.date.contains(text),).toList();
          HomeScreen.moneys.clear();
          setState(() {
            for (var value in result) { 
              HomeScreen.moneys.add(value);
            }
          });
        },
        onCollapseComplete: (){
          MyApp.getData();
          searchController.text = '';
          setState(() {
            
          });
        },
        ),
      ),
      const SizedBox(width: 10,),
      Text("تراکنش ها", style: TextStyle(fontSize:ScreenSize(context).screenWidth < 1004 ? 18.0 : ScreenSize(context).screenWidth * 0.015,),),
      ],),
    );
 }
}

//! My ListTile Widget
class MyListTileWidget extends StatelessWidget {
 final int index;
 const MyListTileWidget({super.key, required this.index});
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration:  BoxDecoration(color: HomeScreen.moneys[index].isReceived ? KGreenColor : KRedColor,
            borderRadius: BorderRadius.circular(15.0),),
            child:  Center(child: Icon(
            HomeScreen.moneys[index].isReceived ? Icons.add : Icons.remove,
            color: Colors.white,
            size: 30.0,),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(HomeScreen.moneys[index].title,
            style: TextStyle(fontSize:ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.015,),),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Row(
                children: [
                  Text('تومان', style: TextStyle(fontSize:ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.015, color: KRedColor),),
                  Text(HomeScreen.moneys[index].price, style: TextStyle(fontSize:ScreenSize(context).screenWidth < 1004 ? 14.0 : ScreenSize(context).screenWidth * 0.015,color: KRedColor),),
                ],
              ),
              Text(HomeScreen.moneys[index].date, style: TextStyle(fontSize:ScreenSize(context).screenWidth < 1004 ? 12.0 : ScreenSize(context).screenWidth * 0.01,),),
            ],
          ),
        ],
      ),
    );
  }
}

//! Empty Widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
              SvgPicture.asset('assets/images/empty.svg',height: 300,width: 300,),
              const SizedBox(height: 10,),
              const Text(' ! تراکنشی موجود نیست '),
              const Spacer(),
      ],
    );
  }
}