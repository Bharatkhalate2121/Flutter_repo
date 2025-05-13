import 'package:flutter/material.dart';

import 'package:flutter_assignment/Models/Data.dart';

class FormWidget extends StatefulWidget {
  final Function(Data) onFormSubmit;
  const FormWidget({Key? key, required this.onFormSubmit}) : super(key: key);
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  Data? formData;
  String _url = "";
  String _description = "";
  bool value = false;
  bool value1 = false;
  bool tnc = false;

  ValueChanged<bool?>? onchangedCheckbox(bool newValue) {
    setState(() {
      value1 = newValue;
    });
  }

  void onChanged(bool newValue) {
    setState(() {
      value = newValue;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "URL"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a URL";
              }
              final urlPattern =
                  r'^(https?:\/\/)?' // Protocol (http, https) - Optional
                  r'((localhost|127\.0\.0\.1)|' // Localhost or 127.0.0.1
                  r'([\w-]+\.)+[\w-]+)' // Domain (e.g., example.com)
                  r'(:\d+)?' // Port (e.g., :45607) - Optional
                  r'(\/[\w\-./?%&=]*)?$'; // Path/query params - Optional

              final regExp = RegExp(urlPattern, caseSensitive: false);

              if (!regExp.hasMatch(value)) {
                return "Please enter a valid URL";
              }
              return null;
            },
            onSaved: (value) {
              _url = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a description";
              }
              return null;
            },
            onSaved: (value) {
              _description = value!;
            },
          ),
          const SizedBox(height: 8),

          FormField<bool>(
            initialValue: value,
            builder: (FormFieldState<bool> state) {
              return Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Aligns items to the left
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Switch"),
                      Switch(
                        value: state.value ?? false, // Default to false if null
                        onChanged: (newValue) {
                          state.didChange(newValue); // Update FormField state
                          onChanged(newValue);
                          // Call parent callback if needed
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
            onSaved: (newValue) {
              value = newValue ?? false; // Save the value properly
            },
          ),

          FormField<bool>(
            initialValue: value1,
            builder: (FormFieldState<bool> state) {
              return Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Aligns items to the left
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Terms And Condiotions"),
                      Checkbox(
                        value: state.value ?? false, // Default to false if null
                        onChanged: (newValue) {
                          state.didChange(newValue); // Update FormField state
                          onchangedCheckbox(newValue!);
                          // Call parent callback if needed
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
            validator: (value) {
              if (value == false) {
                return "Please enter a description";
              }
              tnc = true;
              return null;
            },
            onSaved: (newValue) {
              value1 = newValue ?? false; // Save the value properly
            },
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                formData = Data(null, _url, _description);
                widget.onFormSubmit(formData!);
                // Clear the form fields after submission
                _formKey.currentState!.reset();
                setState(() {
                  _url = "";
                  _description = "";
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Form submitted successfully")),
                );
              } else if (tnc == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Agree terms and conditions")),
                );
              }
            },
            child: const Text("Submit Data"),
          ),
        ],
      ),
    );
  }
}
