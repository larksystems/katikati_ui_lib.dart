import 'dart:html';

typedef void OnEventCallback(Event e);

enum ButtonType {
  // Text buttons
  text,
  outlined,
  contained,

  // Icon buttons
  add,
  remove,
  confirm,
  edit,
}

class ButtonAction {
  String buttonText;
  OnEventCallback onClick;

  ButtonAction(this.buttonText, this.onClick);
}

class Button {
  ButtonElement _element;

  Button(ButtonType buttonType, {String buttonText = '', String hoverText = '', OnEventCallback onClick}) {
    _element = new ButtonElement()
      ..classes.add('button')
      ..title = hoverText;

    onClick = onClick ?? (_) {};
    _element.onClick.listen(onClick);

    switch (buttonType) {
      case ButtonType.text:
        _element.classes.add('button--text');
        _element.text = buttonText;
        break;
      case ButtonType.outlined:
        _element.classes.add('button--outlined');
        _element.text = buttonText;
        break;
      case ButtonType.contained:
        _element.classes.add('button--contained');
        _element.text = buttonText;
        break;

      case ButtonType.add:
        _element.classes.add('button--add');
        break;
      case ButtonType.remove:
        _element.classes.add('button--remove');
        break;
      case ButtonType.confirm:
        _element.classes.add('button--confirm');
        break;
      case ButtonType.edit:
        _element.classes.add('button--edit');
        break;
    }
  }

  Element get renderElement => _element;

  void set visible(bool value) {
    _element.classes.toggle('hidden', !value);
  }

  void set parent(Element value) => value.append(_element);
  void remove() => _element.remove();

  void hide() => _element.setAttribute('hidden', 'true');
  void show() => _element.removeAttribute('hidden');
}
