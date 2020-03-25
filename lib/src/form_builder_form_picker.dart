import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:permission_handler/permission_handler.dart';

class FormBuilderFilePicker extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final Map<String, String> initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;

  final int maxFiles;
  final bool multiple;
  final bool previewImages;
  final Widget selector;
  final FileType fileType;
  final String fileExtension;

  FormBuilderFilePicker({
    @required this.attribute,
    this.initialValue,
    this.validators = const [],
    this.readonly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.valueTransformer,
    this.maxFiles = 1,
    this.multiple = true,
    this.previewImages = true,
    this.selector = const Text('Select File(s)'),
    this.fileType = FileType.any,
    this.fileExtension,
  }) : assert(fileExtension != null || fileType != FileType.custom,
            "For custom fileType a fileExtension must be specified.");

  @override
  _FormBuilderFilePickerState createState() => _FormBuilderFilePickerState();
}

class _FormBuilderFilePickerState extends State<FormBuilderFilePicker> {
  bool _readonly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  Map<String, String> _files;

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _readonly = (_formState?.readOnly == true) ? true : widget.readonly;
    _files = widget.initialValue ?? {};
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  int get _remainingItemCount =>
      widget.maxFiles == null ? null : widget.maxFiles - _files.length;

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _fieldKey,
      enabled: !_readonly,
      initialValue: widget.initialValue,
      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null)
            return widget.validators[i](val);
        }
        return null;
      },
      onSaved: (val) {
        if (widget.valueTransformer != null) {
          var transformed = widget.valueTransformer(val);
          FormBuilder.of(context)
              ?.setAttributeValue(widget.attribute, transformed);
        } else
          _formState?.setAttributeValue(widget.attribute, val);
      },
      builder: (FormFieldState<Map<String, String>> field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readonly,
            errorText: field.errorText,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (widget.maxFiles != null)
                    Text("${_files.length}/${widget.maxFiles}"),
                  InkWell(
                    child: widget.selector,
                    onTap: (_readonly || _remainingItemCount <= 0)
                        ? null
                        : () => pickFiles(field),
                  ),
                ],
              ),
              SizedBox(height: 3),
              defaultFileViewer(_files, field),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFiles(FormFieldState field) async {
    Map<String, String> resultList = {};

    try {
      // PermissionStatus permissionStatus = await SimplePermissions.getPermissionStatus(Permission.ReadExternalStorage);
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] != PermissionStatus.granted)
          throw new Exception("Permission not granted");
      }
      resultList = await FilePicker.getMultiFilePath(
        type: widget.fileType,
        fileExtension: widget.fileExtension,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (resultList != null) {
      setState(() => _files.addAll(resultList));
      // TODO: Pick only remaining number
      field.didChange(_files);
      if (widget.onChanged != null) widget.onChanged(_files);
    }
  }

  void removeFileAtIndex(int index, FormFieldState field) {
    var keysList = _files.keys.toList(growable: false);
    setState(() {
      _files.remove(keysList[index]);
    });
    field.didChange(_files);
    if (widget.onChanged != null) widget.onChanged(_files);
  }

  defaultFileViewer(Map<String, String> files, FormFieldState field) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var count = 5;
        var spacing = 10;
        var itemSize = (constraints.biggest.width - (count * spacing)) / count;
        return Wrap(
          // scrollDirection: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          runSpacing: 10,
          spacing: 10,
          children: List.generate(
            files.keys.length,
            (index) {
              var key = files.keys.toList(growable: false)[index];
              var fileExtension = key.split('.').last.toLowerCase();
              return Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    height: itemSize,
                    width: itemSize,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 2),
                    child: (['jpg', 'jpeg', 'png'].contains(fileExtension) &&
                            widget.previewImages)
                        ? Image.file(
                            File(files[key]),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            child: Icon(
                              getIconData(fileExtension),
                              color: Colors.white,
                              size: 72,
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                  if (!_readonly)
                    InkWell(
                      onTap: () => removeFileAtIndex(index, field),
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.7),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        height: 22,
                        width: 22,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  IconData getIconData(String fileExtension) {
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
