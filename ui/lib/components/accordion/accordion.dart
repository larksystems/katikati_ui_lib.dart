import 'dart:html';

/*
<div class="accordion">
  <div class="accordion-item">
    <div class="accordion-header__wrapper">
      <span class="accordion-indicator">
        <icon />
      </span>
      <header />
    </div>
    <div class="accordion-body__wrapper">
      <body />
    </div>
  </div>
  ...
</div>
*/

const EXPAND_CSS_CLASSNAME = "fas fa-caret-right";
const COLLAPSE_CSS_CLASSSNAME = "fas fa-caret-down";

class AccordionItem {
  String id;
  bool _isOpen = false;
  SpanElement _indicatorIcon;
  DivElement headerElement;
  DivElement bodyElement;
  DivElement renderElement;

  DivElement _headerWrapper;
  DivElement _bodyWrapper;

  AccordionItem(this.id, this.headerElement, this.bodyElement, this._isOpen, {String dataId}) {
    _headerWrapper = DivElement()..className = 'accordion-header__wrapper';
    _indicatorIcon = SpanElement()..className = _isOpen ? COLLAPSE_CSS_CLASSSNAME : EXPAND_CSS_CLASSNAME;
    var indicatorElement = SpanElement()
      ..className = 'accordion-indicator'
      ..append(_indicatorIcon)
      ..onClick.listen((e) {
        e.stopPropagation();
        toggle();
      });
    _headerWrapper
      ..append(indicatorElement)
      ..append(headerElement)
      ..onClick.listen((e) {
        e.stopPropagation();
        toggle();
      });

    _bodyWrapper = DivElement()
      ..className = 'accordion-body__wrapper'
      ..append(bodyElement);
    if (!_isOpen) {
      _bodyWrapper.classes.toggle("hidden", true);
    }

    renderElement = DivElement()
      ..dataset['id'] = 'accordion-item-${id ?? ""}'
      ..className = 'accordion-item'
      ..append(_headerWrapper)
      ..append(_bodyWrapper);
  }

  void expand() {
    _indicatorIcon.className = COLLAPSE_CSS_CLASSSNAME;
    _bodyWrapper.classes.toggle('hidden', false);
    _isOpen = true;
  }

  void collapse() {
    _indicatorIcon.className = EXPAND_CSS_CLASSNAME;
    _bodyWrapper.classes.toggle("hidden", true);
    _isOpen = false;
  }

  void toggle() {
    _isOpen ? collapse() : expand();
  }
}

class Accordion {
  List<AccordionItem> _accordionItems;
  bool _onlyOneOpen;
  DivElement renderElement;

  Accordion(this._accordionItems, {collapseAtStart: true, expandAtStart: false, onlyOneOpen: false}) {
    _onlyOneOpen = onlyOneOpen;
    renderElement = DivElement()..className = "accordion";
    for (var item in _accordionItems) {
      renderElement.append(item.renderElement);
      if (collapseAtStart) {
        item.collapse();
      }
      if (expandAtStart) {
        item.expand();
      }
    }
  }

  AccordionItem queryItem(String id) {
    return _accordionItems.firstWhere((item) => item.id == id);
  }

  void appendItem(AccordionItem item) {
    _accordionItems.add(item);
    renderElement.append(item.renderElement);
  }

  void removeItem(String id) {
    _accordionItems.removeWhere((item) => item.id == id);
    renderElement.children.removeWhere((item) => item.dataset['id'] == 'accordion-item-${id}');
  }

  void collapseAllItems() {
    for (var item in _accordionItems) {
      item.collapse();
    }
  }

  void expandAllItems() {
    for (var item in _accordionItems) {
      item.expand();
    }
  }

  void collapseItem(String id) {
    for (var item in _accordionItems) {
      if (item.id == id) {
        item.collapse();
      }
    }
  }

  void expandItem(String id) {
    for (var item in _accordionItems) {
      if (item.id == id) {
        item.expand();
      } else if (_onlyOneOpen) {
        item.collapse();
      }
    }
  }

  void clear() {
    _accordionItems = [];
    renderElement.children.clear();
  }
}
