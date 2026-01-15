import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController urlC = TextEditingController();
    TextEditingController nameC = TextEditingController();
    final database = FirebaseFirestore.instance.collection('Candidats');
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: database.snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (asyncSnapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: asyncSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Do You want to delete this candidate",
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context);
                                    },
                                    child: Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      database
                                          .doc(
                                            asyncSnapshot.data!.docs[index].id,
                                          )
                                          .delete();
                                      Navigator.of(context);
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  asyncSnapshot.data!.docs[index]['url'],
                                  height: 200,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                asyncSnapshot.data!.docs[index]['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Total Vote: ${asyncSnapshot.data!.docs[index]['vote']}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    database
                                        .doc(
                                          asyncSnapshot.data!.docs[index].id
                                              as String?,
                                        )
                                        .update({
                                          'vote': FieldValue.increment(1),
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    foregroundColor: Colors.black,
                                    fixedSize: Size.fromWidth(double.maxFinite),
                                  ),
                                  child: Text("vote"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No item"));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Text("Add candidate"),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: urlC,
                            decoration: InputDecoration(
                              hintText: "Image Url",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: nameC,
                            decoration: InputDecoration(
                              hintText: "name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              String id = DateTime.now().millisecondsSinceEpoch
                                  .toString();
                              database.doc(id).set({
                                "name": nameC.text,
                                "url": urlC.text,
                                "vote": 0,
                              });
                              nameC.clear();
                              urlC.clear();
                            },
                            child: Text("add"),
                          ),
                        ],
                      ),
                    );
                  },
                );
                Navigator.of(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                fixedSize: Size.fromWidth(double.maxFinite),
              ),
              child: Text("Add more candidate :"),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
