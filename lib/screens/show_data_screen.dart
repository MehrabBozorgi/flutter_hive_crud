import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/model_class.dart';
import 'package:flutter_hive_crud/screens/create_data_screen.dart';
import 'package:flutter_hive_crud/screens/edit_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({Key? key}) : super(key: key);

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {

  @override
  void dispose() {
    Hive.box('PersonBox').close();
    //or
    //Close all boxes
    // Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Data'),
        actions: [
          IconButton(
            onPressed: () {
              //Delete All Box
              Hive.box('PersonBox').clear();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateDataScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: Hive.openBox('PersonBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final hiveBox = Hive.box('PersonBox');
            return ValueListenableBuilder(
              valueListenable: hiveBox.listenable(),
              builder: (context, Box box, child) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('Empty'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: hiveBox.length,
                    itemBuilder: (context, index) {
                      final helper = hiveBox.getAt(index) as ModelClass;
                      return ListTile(
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) => AlertDialog(
                                scrollable: true,
                                title: const Text('Delete'),
                                content: const Text('Do you want delete it?'),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      hiveBox.deleteAt(index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete it',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Return'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  index: index,
                                  age: helper.age,
                                  name: helper.name,
                                  phone: helper.phone,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(helper.name),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone: ${helper.phone}'),
                            Text('Age: ${helper.age}'),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
