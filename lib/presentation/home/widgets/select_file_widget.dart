import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

///
class SelectFileWidget extends StatefulWidget {
  final void Function(String? value)? _onComplete;
  final List<String>? allowedExtensions;
  final String? labelText;
  ///
  SelectFileWidget({
    Key? key,
    void Function(String? value)? onComplete,
    this.allowedExtensions,
    this.labelText,
  }) :
    _onComplete = onComplete,
    super(key: key);
  ///
  @override
  State<SelectFileWidget> createState() => _SelectDirWidgetState();
}

///
class _SelectDirWidgetState extends State<SelectFileWidget> {
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
            FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: widget.allowedExtensions,
            )
            .then((result) {
              if (result != null) {
                final filePath = result.files.first.path;
                setState(() {
                  _editingController.text = '$filePath';
                });
                final onComplete = widget._onComplete;
                if (onComplete != null) {
                  onComplete(filePath);
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