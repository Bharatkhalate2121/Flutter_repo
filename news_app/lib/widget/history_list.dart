import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final dataList = pref.getStringList('history') ?? [];
    setState(() {
      _history = dataList;
    });
  }

  Future<void> _removeItem(int index) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _history.removeAt(index);
    });
    await pref.setStringList('history', _history);
  }

  @override
  Widget build(BuildContext context) {
    return (_history.isNotEmpty)
        ? ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(item),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _removeItem(index),
                ),
                onTap: () {
                  // Handle search re-trigger if needed
                  print("Tapped: $item");
                },
              );
            },
          )
        : SizedBox(child: Text('type something'));
  }
}
