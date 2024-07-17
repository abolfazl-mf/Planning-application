import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:to_do/constans.dart';
import 'package:to_do/screens/to_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/todo_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  TextEditingController txtcontroller = TextEditingController();
  late String v;

  @override
  Widget build(BuildContext context) {
    v='';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 20),
          child: Icon(
            Icons.menu,
            color: Colors.white70,
            size: 33,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 20),
            child: Icon(
              Icons.search,
              color: Colors.white70,
              size: 33,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (txtcontroller.text.isEmpty) {
            AwesomeDialog(
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              body: TextField(
                controller: txtcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 2, color: Colors.grey),
                    ),
                    labelText: 'Please enter your name!'),
              ),
              btnCancelOnPress: () {
                v=txtcontroller.text;
              },
              btnOkOnPress: () {},
              context: context,
            ).show();
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToDo(
                    type: 'add',
                    index: -1,
                    text: '',
                  ),
                ));
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kButtonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                v,
                style: const TextStyle(fontSize: 35, color: Colors.white),
              ),
              const SizedBox(height: 45),
              const Text(
                "Today's task",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: Hive.openBox('todo'),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return todoList();
                  } //
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget todoList() {
    Box todobox = Hive.box('todo');
    return ValueListenableBuilder(
      valueListenable: todobox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return const Center(
              child: Text(
            'No Data!',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ));
        } //
        else {
          return Container(
            height: 470,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(55), bottom: Radius.circular(60)),
              gradient: LinearGradient(colors: [
                Colors.cyan,
                kBackgroundColor,
              ], begin: Alignment.topCenter, end: Alignment.center),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: todobox.length,
                itemBuilder: (context, index) {
                  final Todo todo = box.getAt(index);
                  return GestureDetector(
                    onTap: () {
                      MyNavigator(context, 'update', index, todo.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 40,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(21)),
                        ),
                        color: kDarkBlueColor,
                        child: SizedBox(
                          height: 65,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.circle_outlined,
                                color: kBackgroundColor,
                              ),
                              title: Text(
                                todo.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  dialog(context, index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  MyNavigator(context, String type, int index, String text) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ToDo(
            type: type,
            index: index,
            text: text,
          ),
        ));
  }

  void remove(index) {
    Box box = Hive.box('todo');
    box.deleteAt(index);
  }

  dialog(context, index) {
    return AwesomeDialog(
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Are you sure to delete this task?',
      desc: 'if yes ok do it.',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        remove(index);
      },
      context: context,
    )..show();
  }
}
