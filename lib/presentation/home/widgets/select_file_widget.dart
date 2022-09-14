import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

///
class SelectFileWidget extends StatefulWidget {
  final bool _editable;
  final void Function(String? path)? _onComplete;
  final List<String>? allowedExtensions;
  final String? labelText;
  final Widget icon;
  ///
  SelectFileWidget({
    Key? key,
    editable = false,
    void Function(String? path)? onComplete,
    this.allowedExtensions,
    this.labelText,
    this.icon = const Icon(Icons.more_horiz),
  }) :
    _editable = editable,
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget._editable)
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
          icon: widget.icon,
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