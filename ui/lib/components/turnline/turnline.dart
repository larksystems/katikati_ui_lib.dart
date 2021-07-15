import 'dart:html';
import 'package:katikati_ui_lib/components/accordion/accordion.dart';
import 'package:katikati_ui_lib/components/button/button.dart';


class Turnline {
  DivElement renderElement;
  DivElement _stepsContainer;
  List<TurnlineStep> _steps;

  Turnline(String title) {
    renderElement = new Element.html('''
      <div class="turnline">
        <div class="turnline__title">$title</div>
        <div class="turnline__steps"></div>
      </div>
      ''');

    _steps = [];
    _stepsContainer = renderElement.querySelector('.turnline__steps');
  }

  void addStep(TurnlineStep step) {
    _steps.add(step);
    _stepsContainer.append(step.renderElement);
    step.turnline = this;
  }

}

const STEP_MESSAGES_TEXT = 'Standard messages set';
const STEP_TAGS_TEXT = 'Tags group';

class TurnlineStep {
  Turnline turnline;
  DivElement renderElement;
  DivElement _checkboxElement;
  DivElement _nodeElement;
  DivElement _infoElement;
  String _text;
  bool _open;
  bool _checked;

  TurnlineStep(this._text, this._open, this._checked) {
    renderElement = new Element.html('''
      <div class="step step--folded">
        <div class="step__contents">
          <div class="step__check"></div>
          <div class="step__node"></div>
          <div class="step__info"></div>
        </div>
      </div>
      ''');

    var checkedButton = Button(new ButtonType('button--icon', iconClassName: 'far fa-check-square'));
    checkedButton.visible = _checked;
    var uncheckedButton = Button(new ButtonType('button--icon', iconClassName: 'far fa-square'));
    uncheckedButton.visible = !_checked;

    _checkboxElement = renderElement.querySelector('.step__check');
    _checkboxElement.append(checkedButton.renderElement);
    _checkboxElement.append(uncheckedButton.renderElement);
    _checkboxElement.onClick.listen((e) {
      _checked = !_checked;
      checkedButton.visible = _checked;
      uncheckedButton.visible = !_checked;
    });

    var openNodeButton = Button(new ButtonType('button--icon', iconClassName: 'far fa-circle'));
    openNodeButton.visible = _open;
    var fullNodeButton = Button(new ButtonType('button--icon', iconClassName: 'fas fa-circle'));
    fullNodeButton.visible = !_open;

    _nodeElement = renderElement.querySelector('.step__node');
    _nodeElement.append(openNodeButton.renderElement);
    _nodeElement.append(fullNodeButton.renderElement);
    _nodeElement.onClick.listen((e) {
      _open = !_open;
      openNodeButton.visible = _open;
      fullNodeButton.visible = !_open;
    });

    _infoElement = renderElement.querySelector('.step__info');
    var stepTitle = new DivElement()
      ..classes.add('step__description')
      ..text = _text;

    var stepInfo = new DivElement();
    stepInfo.append(new DivElement()..classes.add('step__messages')..text = STEP_MESSAGES_TEXT);
    stepInfo.append(new DivElement()..classes.add('step__tags')..text = STEP_TAGS_TEXT);

    var item = AccordionItem(null, stepTitle, stepInfo, false);
    item.onToggle = () {
      renderElement.classes.toggle('step--folded', !item.isOpen);
      renderElement.classes.toggle('step--unfolded', item.isOpen);
      reflowTurnlinesCascade(this.turnline);
    };
    _infoElement.append(item.renderElement);
  }
}

void reflowTurnlinesCascade(Turnline turnline) {
  var turnlineElement = turnline.renderElement;
  var nextTurnlineElement = turnlineElement.nextElementSibling;
  while (nextTurnlineElement != null) {
    var padding = turnlineElement
        .querySelector('.turnline__steps')
        .getBoundingClientRect()
        .height;
    nextTurnlineElement.querySelector('.turnline__steps')
      ..style.paddingTop = '${padding}px';
    turnlineElement = nextTurnlineElement;
    nextTurnlineElement = nextTurnlineElement.nextElementSibling;
  }
}
