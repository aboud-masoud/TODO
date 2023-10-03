import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/item.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/ad_helper.dart';

class HomeScereen extends StatefulWidget {
  const HomeScereen({super.key});

  @override
  State<HomeScereen> createState() => _HomeScereenState();
}

class _HomeScereenState extends State<HomeScereen> {
  List<Map<String, dynamic>> myList = [];
  BannerAd? _bannerAd;
  final _todoBox = Hive.box('todo');

  final DateFormat formatter1 = DateFormat('MM/dd');
  final DateFormat formatter2 = DateFormat('hh:mm');

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();

    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _todoBox.keys.map((key) {
      final value = _todoBox.get(key);
      return {
        "key": key,
        "title": value["title"],
        "desc": value['desc'],
        "status": stringParserToEnum(value['status']),
        "createdDate": value['createdDate']
      };
    }).toList();

    setState(() {
      myList = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _todoBox.add(newItem);

    _refreshItems(); // update the UI
  }

  // Update a single item
  Future<void> _updateItem({required int itemKey, required Map<String, dynamic> item}) async {
    await _todoBox.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  Future<void> _deleteItem(int itemKey) async {
    await _todoBox.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Row(
          children: [
            Image.asset(
              "assets/logo.png",
              height: 30,
            ),
            const SizedBox(width: 4),
            const Text("My TODO APP"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showButtomSheet(context: context);
            },
            icon: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Column(
            children: [
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              const TabBar(tabs: [
                Tab(child: Text("All")),
                Tab(child: Text("Todo")),
                Tab(child: Text("Progess")),
                Tab(child: Text("Done")),
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    showList(selectedList: myList),
                    showList(
                      selectedList: myList.where((element) => element["status"] == Status.todo).toList(),
                    ),
                    showList(
                      selectedList: myList.where((element) => element["status"] == Status.progessing).toList(),
                    ),
                    showList(
                      selectedList: myList.where((element) => element["status"] == Status.done).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showList({required List<Map<String, dynamic>> selectedList}) {
    return selectedList.isEmpty
        ? const Center(
            child: Text("Empty list"),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
                itemCount: selectedList.length,
                itemBuilder: (context, index) {
                  final String formattedDate1 = formatter1.format(DateTime.parse(selectedList[index]["createdDate"]));
                  final String formattedDate2 = formatter2.format(DateTime.parse(selectedList[index]["createdDate"]));

                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: selectedList[index]["status"] == Status.todo
                                      ? Colors.red
                                      : selectedList[index]["status"] == Status.progessing
                                          ? Colors.orange
                                          : Colors.green,
                                  borderRadius: BorderRadius.circular(25)),
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Text(
                                  selectedList[index]["status"] == Status.todo
                                      ? "T"
                                      : selectedList[index]["status"] == Status.progessing
                                          ? "P"
                                          : "D",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500, color: Color(0xff444444), fontSize: 35),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedList[index]["title"],
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    selectedList[index]["desc"],
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  formattedDate1,
                                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedDate2,
                                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteItem(selectedList[index]['key']);
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedList[index]["status"] == Status.done
                                              ? Colors.red
                                              : Colors.orange),
                                    ),
                                    child: Icon(
                                      selectedList[index]["status"] == Status.done ? Icons.delete : Icons.edit,
                                      color: selectedList[index]["status"] == Status.done ? Colors.red : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 55, right: 8, top: 8, bottom: 8),
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          );
  }

  void showButtomSheet(
      {required BuildContext context,
      int? itemKey,
      String initTitleValue = "",
      String initDescValue = "",
      Status initStatusValue = Status.todo,
      String initDateValue = ""}) {
    TextEditingController controllerTitle = TextEditingController();
    TextEditingController controllerDesc = TextEditingController();

    controllerTitle.text = initTitleValue;
    controllerDesc.text = initDescValue;

    ValueNotifier<Status> character = ValueNotifier<Status>(initStatusValue);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ValueListenableBuilder<Status>(
              valueListenable: character,
              builder: (context, snapshot, child) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        Expanded(
                            child: Text(
                          itemKey == null ? "Add New Item" : "Edit Item",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        TextButton(
                          onPressed: () {
                            if (itemKey == null) {
                              //ADD
                              if (controllerTitle.text.isNotEmpty && controllerDesc.text.isNotEmpty) {
                                _createItem({
                                  "title": controllerTitle.text,
                                  "desc": controllerDesc.text,
                                  "status": enumParserToString(character.value),
                                  "createdDate": DateTime.now().toString()
                                });
                                Navigator.pop(context);
                              }
                            } else {
                              //EDIT
                              _updateItem(itemKey: itemKey, item: {
                                "title": controllerTitle.text,
                                "desc": controllerDesc.text,
                                "status": enumParserToString(character.value),
                                "createdDate": DateTime.now().toString()
                              });

                              Navigator.pop(context);
                            }

                            setState(() {});
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controllerTitle,
                        decoration: const InputDecoration(hintText: "Title", border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controllerDesc,
                        maxLines: 5,
                        decoration: const InputDecoration(hintText: "Desc", border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: [
                        Radio<Status>(
                          value: Status.todo,
                          groupValue: character.value,
                          onChanged: (Status? value) {
                            character.value = value!;
                          },
                        ),
                        const Text('Todo')
                      ],
                    ),
                    Row(
                      children: [
                        Radio<Status>(
                          value: Status.progessing,
                          groupValue: character.value,
                          onChanged: (Status? value) {
                            character.value = value!;
                          },
                        ),
                        const Text('progressing')
                      ],
                    ),
                    Row(
                      children: [
                        Radio<Status>(
                          value: Status.done,
                          groupValue: character.value,
                          onChanged: (Status? value) {
                            character.value = value!;
                          },
                        ),
                        const Text('Done')
                      ],
                    ),
                  ],
                );
              });
        });
  }

  String enumParserToString(Status status) {
    switch (status) {
      case Status.todo:
        return "todo";
      case Status.progessing:
        return "progessing";
      case Status.done:
        return "done";
    }
  }

  Status stringParserToEnum(String status) {
    if (status == "todo") {
      return Status.todo;
    } else if (status == "progessing") {
      return Status.progessing;
    } else {
      return Status.done;
    }
  }
}
