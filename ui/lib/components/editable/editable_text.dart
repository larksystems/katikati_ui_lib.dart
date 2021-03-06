import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';

/*
<span class="text-edit text-edit--editing">
  <span class="text-edit__text" contentEditable></span>
  <span class="text-edit__actions">
      <button class="button button--text" title="">...</button>
  </span>
</span>
*/

class TextEdit {
  SpanElement renderElement;
  String _text;

  bool _removable;

  SpanElement _textSpan;
  SpanElement _textActions;
  Button _editButton;
  Button _deleteButton;
  Button _confirmButton;
  Button _cancelButton;

  bool _isEditing = false;

  void Function(String) onEdit = (_) {};
  void Function() onDelete = () {};
  void Function() onSelect = () {};
  void Function() onAccept = () {};
  void Function() onCancel = () {};

  TextEdit(this._text, {bool removable = false}) {
    _removable = removable;

    renderElement = SpanElement()..classes.add('text-edit');

    _textSpan = SpanElement()
      ..classes.add('text-edit__text')
      ..dataset['placeholder'] = "untitled"
      ..onClick.listen((e) {
        if (!_isEditing) return;
        e.stopPropagation();
      })
      ..onKeyDown.listen((event) {
        if (!_isEditing) return;
        if (event.keyCode == KeyCode.ENTER) {
          event.preventDefault();
          _confirmEdit();
        }
        if (event.keyCode == KeyCode.ESC) {
          event.preventDefault();
          _cancelEditing();
        }
      });
    _textSpan.innerText = this._text;

    _editButton = Button(ButtonType.edit, onClick: (e) {
      e.stopPropagation();
      beginEdit();
    });
    _confirmButton = Button(ButtonType.confirm, onClick: (e) {
      e.stopPropagation();
      _confirmEdit();
    });
    _cancelButton = Button(ButtonType.cancel, onClick: (e) {
      e.stopPropagation();
      _cancelEditing();
    });
    _deleteButton = Button(ButtonType.remove, onClick: (e) {
      e.stopPropagation();
      _delete();
    });

    _textActions = SpanElement()..classes.add('text-edit__actions');
    _textActions.append(_editButton.renderElement);
    if (_removable) {
      _textActions.append(_deleteButton.renderElement);
    }

    renderElement..append(_textSpan)..append(_textActions);
  }

  void beginEdit() {
    _isEditing = true;
    _textSpan.contentEditable = "true";
    renderElement.classes.toggle("text-edit--editing", true);

    _textActions.children.clear();
    _textActions..append(_confirmButton.renderElement)..append(_cancelButton.renderElement);
    focus();
  }

  void focus() {
    _textSpan.focus();
  }

  void _confirmEdit() {
    _resetActions();
    if (_text != _textSpan.innerText) {
      _text = _textSpan.innerText;
      onEdit(_text);
    }
  }

  void _cancelEditing() {
    _resetActions();
    _textSpan.innerText = _text;
    onCancel();
  }

  void _delete() {
    _resetActions();
    onDelete();
  }

  void _resetActions() {
    _isEditing = false;
    _textSpan..contentEditable = "false";
    renderElement.classes.toggle("text-edit--editing", false);

    _textActions.children.clear();
    _textActions.append(_editButton.renderElement);
    if (_removable) {
      _textActions.append(_deleteButton.renderElement);
    }
  }
}
