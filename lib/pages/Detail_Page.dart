import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/database_service.dart';

class DetailScreen extends StatefulWidget {
  final Todo todo;
  final String todoId;

  DetailScreen({required this.todo, required this.todoId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<dynamic> items;
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _addItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    items = widget.todo.listitems.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => Card(
                  elevation: 3,
                  child: CheckboxListTile(
                    title: Text(items[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        widget.todo.listitems[items[index]] = value ?? false;
                        _updateTodoItem(widget.todoId, widget.todo);
                      });
                    },
                    value: widget.todo.listitems[items[index]] ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildAddItemTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _addItemController,
              decoration: InputDecoration(
                hintText: 'Add new item',
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: _addListItem,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addListItem() {
    String newItem = _addItemController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        widget.todo.listitems[newItem] = false;
        _updateTodoItem(widget.todoId, widget.todo);
        _addItemController.clear();
        items = widget.todo.listitems.keys.toList();
      });
    }
  }

  void _updateTodoItem(String todoId, Todo todo) {
    _databaseService.updateTodo(todoId, todo);
  }
}
