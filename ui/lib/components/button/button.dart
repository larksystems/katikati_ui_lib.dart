import 'dart:html';

typedef void OnEventCallback(Event e);

class ButtonType {
  final String className;
  final String iconClassName;

  const ButtonType(this.className, {this.iconClassName});

  static const text = ButtonType("button--text");
  static const outlined = ButtonType("button--outlined");
  static const contained = ButtonType("button--contained");
  static const add = ButtonType("button--icon", iconClassName: "fas fa-plus");
  static const remove = ButtonType("button--icon", iconClassName: "far fa-trash-alt");
  static const edit = ButtonType("button--icon", iconClassName: "fas fa-pen");
  static const confirm = ButtonType("button--icon", iconClassName: "fas fa-check");
  static const cancel = ButtonType("button--icon", iconClassName: "fas fa-times");
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
      ..classes.add(buttonType.className)
      ..title = hoverText
      ..text = buttonText;

    if (buttonType.iconClassName != null) {
      var icon = SpanElement()..className = buttonType.iconClassName;
      _element.append(icon);
    }

    onClick = onClick ?? (_) {};
    _element.onClick.listen(onClick);
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
