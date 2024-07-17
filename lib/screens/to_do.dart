

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do/constans.dart';
import 'package:to_do/models/todo_model.dart';
import 'package:to_do/screens/home_screen.dart';

class ToDo extends StatelessWidget {
   ToDo({Key? key, required this.type, required this.index, required this.text}) : super(key: key);
   final String type;
   final int index;
   final String text;

    TextEditingController txtcontroller= TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(type=='update'){
      txtcontroller.text=text;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title:  Text(
          type=='add'?'Add Todo':'Update Todo',
          style: const TextStyle(color: Colors.blueAccent),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blueAccent,
        ),
      ),
      body:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children:  [
            const SizedBox(height: 10,),
            TextField(
              controller: txtcontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.grey
                  ),
                ),
                labelText: type=='add'?'Add Task Content':'Update Task Content',
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed:(){
                  onButtonPressed(txtcontroller.text,context);
                },
                child:  Text(
                  type=='add'?'Add':'Update',
                  style: const TextStyle(fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kButtonColor),
                fixedSize: MaterialStateProperty.all(
                    type=='add'?const Size(100, 40):const Size(111, 43)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String text,context) {
    if(type=='add'){
      add(text);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeScreen(),));
    }//
    else{
      update(text);
    }
  }

  add(String text)async{
  var box= await Hive.openBox('todo');
  Todo todo= Todo(text);
  box.add(todo);
  }
  update(String text)async{
    var box= await Hive.openBox('todo');
    Todo todo= Todo(text);
    box.putAt(index, todo);
  }
}
