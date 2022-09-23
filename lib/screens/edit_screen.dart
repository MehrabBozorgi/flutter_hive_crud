import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/model_class.dart';
import 'package:hive/hive.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.phone,
    required this.index,
  }) : super(key: key);
  final String name;
  final int age;
  final int phone;
  final int index;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _phoneController.text = widget.phone.toString();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: widget.name,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: widget.age.toString(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: widget.phone.toString(),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  final value = ModelClass(
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                    phone: int.parse(_phoneController.text),
                  );

                  Hive.box('PersonBox').putAt(widget.index, value);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
