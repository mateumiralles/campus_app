import 'package:flutter/material.dart';

import 'package:campus_app/citm.dart';

class MailUsersScreen extends StatefulWidget {
  const MailUsersScreen({Key? key}) : super(key: key);

  @override
  State<MailUsersScreen> createState() => _MailUsersScreenState();
}

class _MailUsersScreenState extends State<MailUsersScreen> {
  bool _loaded = false;
  List<CitmUser> usersList = [];
  List<CitmUser> searchUsersList = [];

  getDataUsers() async {
    usersList = await CITM.getCitmUsers();
    searchUsersList = usersList;
    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataUsers();
  }

  void filter(String enteredKeyword) {
    List<CitmUser> results = [];
    if (enteredKeyword.isEmpty) {
      // mostrar tots els resultats si la cerca esta buida
      results = usersList;
    } else {
      results = usersList
          .where((user) => user.fullname
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      searchUsersList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DESTINATARIS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => filter(value),
              decoration: const InputDecoration(
                  labelText: 'Cerca', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _loaded
                  ? searchUsersList.isNotEmpty
                      ? Scrollbar(
                          child: ListView.builder(
                            itemCount: searchUsersList.length,
                            itemBuilder: (context, index) => Card(
                              color: Colors.blue[100],
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                title: Text(
                                  searchUsersList[index].fullname,
                                ),
                                subtitle: Text(
                                  searchUsersList[index].username,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Text(
                          "No s'han trobat resultats",
                          style: TextStyle(fontSize: 18),
                        )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
