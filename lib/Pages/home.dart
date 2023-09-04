import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_recipe_9_july_2023/Model/RecipeModel.dart';
import 'package:food_recipe_9_july_2023/Pages/webDetail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading=false;
  Random rand=new Random();
  String query='chicken';
  final spinkit = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Future<RecipeModel> getRecipeData() async{
    isLoading=false;
    final response=await http.get(Uri.parse('https://api.edamam.com/search?q=$query&app_id=e18b24c6&app_key=c70b69a2be0c1bfd900cb5044d2535c3'));
    var data=jsonDecode(response.body.toString());
    isLoading=true;
    if(response.statusCode==200){
      return RecipeModel.fromJson(data);
    } else{
      return throw Exception('Error');
    }
  }
  final searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff213a50),
                Color(0xff071938),
              ]
            )
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20.0),
                       color: Colors.white38
                     ),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                       child: Row(
                         children: [
                           GestureDetector(
                             onTap:(){
                                  query=searchController.text;
                                  setState(() {
                                    searchController.clear();
                                    FocusScope.of(context).unfocus();
                                  });
                     },
                               child: Icon(Icons.search,color: Colors.black,size: 30,)),
                           SizedBox(width: mediaQuery.size.width*0.02,),
                           Expanded(
                             child: TextFormField(
                               controller: searchController,
                               style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 20
                               ),
                               decoration: InputDecoration(
                                 hintText: 'Search Any Food Recipe Here',
                                 border: InputBorder.none
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                   ),
                  SizedBox(height: mediaQuery.size.height*0.02,),
                  Text('What Do You Want To Cook Today?',style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: GoogleFonts.poppins().fontFamily,fontWeight: FontWeight.bold),),
                  SizedBox(height: mediaQuery.size.height*0.01,),
                  Text('Let\'s Cook Something New!',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: GoogleFonts.poppins().fontFamily),),
                  SizedBox(height: mediaQuery.size.height*0.02,),
                  Expanded(
                      child: FutureBuilder(
                        future: getRecipeData(),
                        builder: (context,snapshot){
                          if(!isLoading){
                            return Center(
                              child: spinkit,
                            );
                          }else{
                            return ListView.builder(
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data!.hits!.length,
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WebDetail(snapshot.data!.hits![index].recipe!.url.toString())));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
                                              child: Image.network(snapshot.data!.hits![index].recipe!.image.toString(),fit: BoxFit.cover,height: 200,width: mediaQuery.size.width,)),
                                          Positioned(
                                            child: Container(
                                              color:Colors.grey.withOpacity(0.5),
                                              child: Text(snapshot.data!.hits![index].recipe!.label.toString(),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                                            ),
                                            bottom: 10.0,
                                            left: 10.0,
                                          ),
                                          Positioned(
                                            child: ClipRRect(
                                              borderRadius:BorderRadius.only(topRight:Radius.circular(10.0)),
                                              child: Container(
                                                color:Colors.grey,
                                                child: Row(
                                                children:[
                                                  Icon(Icons.local_fire_department_outlined,size: 40,),
                                                  Text(snapshot.data!.hits![index].recipe!.calories.toString().substring(0,6),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                                    ]
                                    )
                                              ),
                                            ),
                                            right: 0.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}