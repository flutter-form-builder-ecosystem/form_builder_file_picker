import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FormBuilderFilePicker extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final Map<String, String> initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;

  final int maxImages;
  final CupertinoOptions cupertinoOptions;
  final MaterialOptions materialOptions;

  FormBuilderFilePicker({
    @required this.attribute,
    this.initialValue,
    this.validators = const [],
    this.readonly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.valueTransformer,
    this.maxImages = 1,
    this.cupertinoOptions = const CupertinoOptions(),
    this.materialOptions = const MaterialOptions(),
  });

  @override
  _FormBuilderFilePickerState createState() => _FormBuilderFilePickerState();
}

class _FormBuilderFilePickerState extends State<FormBuilderFilePicker> {
  bool _readonly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  Map<String, String> _images = {};

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _readonly = (_formState?.readOnly == true) ? true : widget.readonly;
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  int get _remainingItemCount => widget.maxImages - _images.length;

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
          child: Container(
            height: (_images.keys.length == 0) ? 50 : 200,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${_images.length}/${widget.maxImages}"),
                    FlatButton.icon(
                      icon: Icon(Icons.add),
                      label: Text("Add Attachment(s)"),
                      onPressed: (_readonly || _remainingItemCount <= 0)
                          ? null
                          : () => pickFiles(field),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(_images.keys.length, (index) {
                      var key = _images.keys.toList(growable: false)[index];
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 2),
                            child: (key.contains('.jpg') ||
                                    key.contains('.jpeg') ||
                                    key.contains('.png'))
                                ? Image.file(
                                    File(_images[key]),
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 150,
                                  )
                                : Container(
                                    child: Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.white,
                                      size: 72,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    width: 150,
                                    height: 150,
                                  ),
                          ),
                          if (!_readonly)
                            InkWell(
                              onTap: () => removeImageAtIndex(index, field),
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
                    }),
                  ),
                ),
              ],
            ),
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
      resultList = await FilePicker.getMultiFilePath();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList != null)
        _images.addAll(resultList); // .addAll(resultList);
      // if (error == null) _error = 'No Error Dectected';
    });
    field.didChange(_images);
    if (widget.onChanged != null) widget.onChanged(_images);
  }

  void removeImageAtIndex(int index, FormFieldState field) {
    var keysList = _images.keys.toList(growable: false);
    setState(() {
      _images.remove(keysList[index]);
    });
    field.didChange(_images);
    if (widget.onChanged != null) widget.onChanged(_images);
  }
}
