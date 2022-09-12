import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

///
class SelectDirWidget extends StatefulWidget {
  final void Function(String? value)? _onComplete;
  final String? labelText;
  ///
  SelectDirWidget({
    Key? key,
    void Function(String? value)? onComplete,
    this.labelText,
  }) :
    _onComplete = onComplete,
    super(key: key);
  ///
  @override
  State<SelectDirWidget> createState() => _SelectDirWidgetState();
}

///
class _SelectDirWidgetState extends State<SelectDirWidget> {
  final TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _editingController,
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            FilePicker.platform.getDirectoryPath()
            .then((value) {
              if (value != null) {
                setState(() {
                  _editingController.text = '$value';
                });
                final onComplete = widget._onComplete;
                if (onComplete != null) {
                  onComplete(value);
                }
              }      
            });
          }, 
          icon: Icon(Icons.more_horiz),
        ),        
      ],
    );
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}