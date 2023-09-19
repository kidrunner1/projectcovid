
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_check.dart';
import '../../result/collect_check.dart';
import 'form_check.dart';

class HomeScreen_check extends StatefulWidget {
  const HomeScreen_check({super.key});

  @override
  State<HomeScreen_check> createState() => _HomeScreen_checkState();
}

class _HomeScreen_checkState extends State<HomeScreen_check> {
  void _deleteCheck(BuildContext context, int index) {
    Provider.of<CheckProvider>(context, listen: false)
        .deleteCheckModel(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 154, 154),
        title: Text("บันทึกผลตรวจโควิด-19 รายวัน"),
      ),
      body: Consumer(builder: ((context, CheckProvider provider, child) {
        var count = provider.check.length;
        if (count <= 0) {
          return const Center(
              child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 35),
          ));
        } else {
          return ListView.builder(
              itemCount: provider.check.length,
              itemBuilder: (context, int index) {
                var data = provider.check[index];
                final numberDay = count - index;
                return Container(
                  height: 100,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    margin: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 84,
                              child: ElevatedButton(
                                
                                // ignore: sort_child_properties_last
                                child: ListTile(
                                  dense: false,
                                  title: Text(
                                    "บันทึกผลวันที่ ${numberDay}",
                                    style:const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                                style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.grey[200],
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal),
                                          elevation: 10,
                                shape:  RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(30.0),
                                    )),
                                 onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CollectCheck(
                                            check: data,
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                           
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<CheckProvider>(context, listen: false)
                                  .deleteCheckModel(index);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      })),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[200],
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CheckScreen();
            }));
          }),
    );
  }
}
