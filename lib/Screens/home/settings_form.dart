import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockly/models/user_model.dart';
import 'package:stockly/services/database.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  String? _currentName;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '$UID');

    return StreamBuilder<DocumentSnapshot>(
      stream: db.StockCollection.doc(UID).snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Retrieve current name from Firestore
        final String currentName =
            (snapshots.data?.data() as Map<String, dynamic>?)?['NAME'] ?? '';

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Heading
                const Text(
                  'Update Username',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Name Input Field
                TextFormField(
                  initialValue: currentName,
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter new name',
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                const SizedBox(height: 20),

                // Update Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await db.StockCollection.doc(UID).update({
                          'NAME': _currentName ?? currentName,
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
