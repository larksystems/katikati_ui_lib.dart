import 'dart:html';
import "dart:math";
import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:katikati_ui_lib/components/nav/button_links.dart';
import 'package:katikati_ui_lib/components/turnline/turnline.dart';
import 'package:uuid/uuid.dart';

import 'package:katikati_ui_lib/components/nav/nav_header.dart';
import 'package:katikati_ui_lib/components/nav/sidebar_icons.dart';
import 'package:katikati_ui_lib/components/snackbar/snackbar.dart';
import 'package:katikati_ui_lib/components/banner/banner.dart';
import 'package:katikati_ui_lib/components/auth/auth.dart' as auth;
import 'package:katikati_ui_lib/components/auth/auth_header.dart';
import 'package:katikati_ui_lib/components/brand_asset/brand_asset.dart' as brand;
import 'package:katikati_ui_lib/components/url_view/url_view.dart';
import 'package:katikati_ui_lib/components/editable/editable_text.dart';
import 'package:katikati_ui_lib/components/tabs/tabs.dart';
import 'package:katikati_ui_lib/components/conversation/conversation_item.dart';
import 'package:katikati_ui_lib/components/messages/freetext_message_send.dart';
import 'package:katikati_ui_lib/components/tag/tag.dart';
import 'package:katikati_ui_lib/components/logger.dart';

DivElement snackbarContainer = querySelector('#snackbar-container');
ButtonElement snackbarTrigger = querySelector('#show-snackbar');
DivElement bannerContainer = querySelector('#banner-container');
ButtonElement showBannerTrigger = querySelector('#show-banner');
ButtonElement hideBannerTrigger = querySelector('#hide-banner');
DivElement authViewContainer = querySelector('#auth-view');
DivElement authHeaderViewContainer = querySelector('#auth-header');
ButtonElement authHeaderSimulateSignInTrigger = querySelector('#auth-header-simulate-signin');
ButtonElement authHeaderSimulateSignOutTrigger = querySelector('#auth-header-simulate-signout');
DivElement navHeaderViewContainer = querySelector('#nav-header');
DivElement brandAssetsContainer = querySelector('#brand-assets');
ButtonElement getURLParamsButton = querySelector('#get-url-params');
DivElement editableTextContainer = querySelector('#editable-text-wrapper');
DivElement buttonLinksContainer = querySelector('#button-links-wrapper');
DivElement tabsContainer = querySelector('#tabs-wrapper');
ButtonElement removeTabButton = querySelector('#remove-tab');
ButtonElement addTabButton = querySelector('#add-tab');
ButtonElement selectTabButton = querySelector('#select-tab');
ParagraphElement tabStatusMessage = querySelector('#tab-status');
DivElement toggleIconButtonsContainer = querySelector("#toggle-icon-buttons-wrapper");
DivElement freetextMessageSendContainer = querySelector('#freetext-message-send--wrapper');

DivElement conversationItemsContainer = querySelector('#conversation-items-wrapper');
DivElement conversationItemSimulateContainer = querySelector('#conversation-items-wrapper-simulate');
ButtonElement conversationSimulateSelect = querySelector('#conversation-item-simulate-select');
ButtonElement conversationSimulateUnselect = querySelector('#conversation-item-simulate-unselect');
ButtonElement conversationSimulateCheck = querySelector('#conversation-item-simulate-check');
ButtonElement conversationSimulateUncheck = querySelector('#conversation-item-simulate-uncheck');
ButtonElement conversationSimulateRead = querySelector('#conversation-item-simulate-read');
ButtonElement conversationSimulateUnread = querySelector('#conversation-item-simulate-unread');
ButtonElement conversationSimulateNormal = querySelector('#conversation-item-simulate-normal');
ButtonElement conversationSimulateFailed = querySelector('#conversation-item-simulate-failed');
ButtonElement conversationSimulatePending = querySelector('#conversation-item-simulate-pending');
ButtonElement conversationSimulateDraft = querySelector('#conversation-item-simulate-draft');
ButtonElement conversationAddWarning = querySelector("#conversation-item-add-warning");
ButtonElement conversationRemoveWarning = querySelector("#conversation-item-remove-warning");
DivElement tagContainer = querySelector('#tag--wrapper');
DivElement turnlinesContainer = querySelector('#turnlines');

Map<String, ButtonElement> setURLParamsButton = {
  "conversation-id": querySelector('#set-url-params--conversation-id') as ButtonElement,
  "conversation-list-id": querySelector('#set-url-params--conversation-list-id') as ButtonElement,
  "conversation-id-filter": querySelector('#set-url-params--conversation-id-filter') as ButtonElement,
  "include-filter": querySelector('#set-url-params--include-filter') as ButtonElement,
  "exclude-filter": querySelector('#set-url-params--exclude-filter') as ButtonElement,
  "include-after-date": querySelector('#set-url-params--include-after-date') as ButtonElement,
  "exclude-after-date": querySelector('#set-url-params--exclude-after-date') as ButtonElement,
};

Logger logger = Logger('script.dart');
final _random = Random();
final uuid = Uuid();

void main() {
  // snackbar
  SnackbarView snackbarView = SnackbarView();
  snackbarContainer.append(snackbarView.snackbarElement);
  snackbarTrigger.onClick.listen((_) {
    snackbarView.showSnackbar("Welcome to the Katikati UI library!", SnackbarNotificationType.success);
  });

  // banner
  BannerView bannerView = BannerView();
  bannerContainer.append(bannerView.bannerElement);
  showBannerTrigger.onClick.listen((_) {
    bannerView.showBanner("Welcome to the Katikati UI library!");
  });
  hideBannerTrigger.onClick.listen((_) {
    bannerView.hideBanner();
  });

  // auth view
  var authMainView = auth.AuthMainView(
      brand.AVF, "Title", "Description appear here", [auth.GMAIL_DOMAIN_INFO, auth.LARK_DOMAIN_INFO], (domain) {
    window.alert("Trying to login with domain: $domain");
  });
  authViewContainer.append(authMainView.authElement);

  // auth inside header
  AuthHeaderView authHeaderView = AuthHeaderView(() {
    window.alert("Firebase login should be called.");
  }, () {
    window.alert("Firebase logout should be called.");
  });
  authHeaderViewContainer.append(authHeaderView.authElement);
  authHeaderSimulateSignInTrigger.onClick.listen((_) {
    authHeaderView.signIn("Username", "packages/katikati_ui_lib/globals/assets/profile.png");
  });
  authHeaderSimulateSignOutTrigger.onClick.listen((_) {
    authHeaderView.signOut();
  });

  // nav header
  NavHeaderView navHeaderView = NavHeaderView();
  navHeaderViewContainer.append(navHeaderView.navViewElement);
  navHeaderView.projectLogos = ["packages/katikati_ui_lib/globals/assets/logo.png"];
  navHeaderView.projectTitle = "Project name";
  navHeaderView.projectSubtitle = "Subtitle";
  navHeaderView.navContent = DivElement()..appendText("Some content like links, dropdown");
  navHeaderView.authHeader = authHeaderView;

  // logos
  var avfLogo = brand.AVF.logo(height: 64)..style.marginRight = "32px";
  brandAssetsContainer.append(avfLogo);
  var katikatiLogo = brand.KATIKATI.logo(height: 64)..style.marginRight = "32px";
  brandAssetsContainer.append(katikatiLogo);
  var ifrcLogo = brand.IFRC.logo(height: 64, className: "logo");
  brandAssetsContainer.append(ifrcLogo);

  // url view
  var urlView = UrlView();
  getURLParamsButton.onClick.listen((_) {
    printURLViewParams(urlView);
  });
  setURLParamsButton["conversation-id"].onClick.listen((_) {
    urlView.setPageUrlConversationId("conv-id");
  });
  setURLParamsButton["conversation-list-id"].onClick.listen((_) {
    urlView.setPageUrlConversationList("conv-list-id");
  });
  setURLParamsButton["conversation-id-filter"].onClick.listen((_) {
    urlView.setPageUrlFilterConversationId("filter-a");
  });
  setURLParamsButton["include-filter"].onClick.listen((_) {
    urlView.setPageUrlFilterTags(TagFilterType.include, Set()..add("hello")..add("world"));
  });
  setURLParamsButton["exclude-filter"].onClick.listen((_) {
    urlView.setPageUrlFilterTags(TagFilterType.exclude, Set()..add("welcome")..add("home"));
  });
  setURLParamsButton["include-after-date"].onClick.listen((_) {
    urlView.setPageUrlFilterAfterDate(TagFilterType.include, DateTime(2020, 1, 1, 3, 5));
  });
  setURLParamsButton["exclude-after-date"].onClick.listen((_) {
    urlView.setPageUrlFilterAfterDate(TagFilterType.exclude, DateTime(2020, 2, 3, 16, 20));
  });

  // editable text
  var textEditable = TextEdit("text", removable: true)
    ..onEdit = (value) {
      window.alert("New text: ${value}");
    }
    ..onDelete = () {
      window.alert("Requesting delete...");
    };
  editableTextContainer.append(textEditable.renderElement);
  var textEditableDefault = TextEdit("", removable: true)
    ..onEdit = (value) {
      window.alert("New text: ${value}");
    }
    ..onDelete = () {
      window.alert("Requesting delete...");
    };
  editableTextContainer.append(textEditableDefault.renderElement);
  textEditableDefault.beginEdit();

  // Button links
  var links = [Link("Dashboard", "#dashboard"), Link("Converse", "#converse")];
  var buttonLinks = ButtonLinksView(links, "#dashboard", openInNewTab: true);
  buttonLinksContainer.append(buttonLinks.renderElement);

  // tabs
  var allTabs = [
    TabView("a", "Tab A", DivElement()..style.padding = "30px"..innerText = "Content A"),
    TabView("b", "Tab B", DivElement()..style.padding = "30px"..innerText = "Content B"),
    TabView("c", "Tab C", DivElement()..style.padding = "30px"..innerText = "Content C"),
    TabView("d", "Tab D", DivElement()..style.padding = "30px"..innerText = "Content D"),
  ];
  var tabsView = TabsView(allTabs, defaultSelectedID: "b");
  tabsContainer.append(tabsView.renderElement);
  var _tabIDs = ["a", "b", "c", "d"];
  removeTabButton.onClick.listen((_) {
    var randomID = _tabIDs[_random.nextInt(_tabIDs.length)];
    tabStatusMessage.innerText = "Removing tab with id: $randomID";
    allTabs.removeWhere((tab) => tab.id == randomID);
    _tabIDs.remove(randomID);
    tabsView.setTabs(allTabs);
  });
  addTabButton.onClick.listen((_) {
    var randomID = uuid.v4().split("-").first;
    var tabView = TabView(randomID, "Tab $randomID", DivElement()..innerText = "Content $randomID");
    allTabs.add(tabView);
    _tabIDs.add(randomID);
    tabsView.setTabs(allTabs);
  });
  selectTabButton.onClick.listen((_) {
    var randomID = _tabIDs[_random.nextInt(_tabIDs.length)];
    tabStatusMessage.innerText = "Selecting tab with id: $randomID";
    tabsView.selectTab(randomID);
  });

  // Toggle icon buttons
  var toggleUserPresenceButton = IconButtonView("user_presence", "users", false)
    ..onToggle.listen((inView) {
      window.alert("Command for user_presence - view $inView");
    });
  toggleIconButtonsContainer.append(toggleUserPresenceButton.renderElement);
  var toggleNotesButton = IconButtonView("notes", "sticky-note", true)
    ..onToggle.listen((inView) {
      window.alert("Command for notes - view $inView");
    });
  toggleIconButtonsContainer.append(toggleNotesButton.renderElement);
  var toggleTagsButton = IconButtonView("tags", "tag", false)
    ..onToggle.listen((inView) {
      window.alert("Command for tags - view $inView");
    });
  toggleIconButtonsContainer.append(toggleTagsButton.renderElement);

  // Conversation items
  var conversationItem = ConversationItemView("000cbc0c", "Hello, this is an example preview message that is long",
      ConversationItemStatus.normal, ConversationReadStatus.read,
      defaultSelected: true)
    ..onSelect.listen((id) {
      logger.debug("Choosing conversation $id");
    })
    ..onCheck.listen((id) {
      logger.debug("Selecting conversation $id");
    })
    ..onUncheck.listen((id) {
      logger.debug("Deselecting conversation $id");
    });
  conversationItemsContainer.append(conversationItem.renderElement);

  var conversationDraft = ConversationItemView("000cbc0c", "Hello, this is an example preview message that is long",
      ConversationItemStatus.draft, ConversationReadStatus.read);
  conversationItemsContainer.append(conversationDraft.renderElement);

  var conversationPending = ConversationItemView("000cbc0c", "Hello, this is an example preview message that is long",
      ConversationItemStatus.pending, ConversationReadStatus.read);
  conversationItemsContainer.append(conversationPending.renderElement);

  var conversationFailed = ConversationItemView("000cbc0c", "Hello, this is an example preview message that is long",
      ConversationItemStatus.failed, ConversationReadStatus.read);
  conversationItemsContainer.append(conversationFailed.renderElement);

  var conversationSimulateItem = ConversationItemView(
      "simulate_id",
      "Hello, this is an example preview message that is long",
      ConversationItemStatus.normal,
      ConversationReadStatus.read,
      checkEnabled: true,
      warnings: Set.from([ConversationWarning.notInFilterResults]));
  conversationSimulateItem.onSelect.listen((_) {
    conversationSimulateItem.select();
  });
  conversationItemSimulateContainer.append(conversationSimulateItem.renderElement);

  conversationSimulateSelect.onClick.listen((_) {
    conversationSimulateItem.select();
  });
  conversationSimulateUnselect.onClick.listen((_) {
    conversationSimulateItem.unselect();
  });
  conversationSimulateCheck.onClick.listen((_) {
    conversationSimulateItem.check();
  });
  conversationSimulateUncheck.onClick.listen((_) {
    conversationSimulateItem.uncheck();
  });
  conversationSimulateRead.onClick.listen((_) {
    conversationSimulateItem.markAsRead();
  });
  conversationSimulateUnread.onClick.listen((_) {
    conversationSimulateItem.markAsUnread();
  });
  conversationSimulateNormal.onClick.listen((_) {
    conversationSimulateItem.updateStatus(ConversationItemStatus.normal);
  });
  conversationSimulateFailed.onClick.listen((_) {
    conversationSimulateItem.updateStatus(ConversationItemStatus.failed);
  });
  conversationSimulatePending.onClick.listen((_) {
    conversationSimulateItem.updateStatus(ConversationItemStatus.pending);
  });
  conversationSimulateDraft.onClick.listen((_) {
    conversationSimulateItem.updateStatus(ConversationItemStatus.draft);
  });
  conversationAddWarning.onClick.listen((_) {
    conversationSimulateItem.setWarnings(Set.from([ConversationWarning.notInFilterResults]));
  });
  conversationRemoveWarning.onClick.listen((_) {
    conversationSimulateItem.resetWarnings();
  });

  // Freetext message send
  var freetextMessageSend = FreetextMessageSendView("Default text", maxLength: 30);
  freetextMessageSend.onSend.listen((value) {
    window.alert("Sending: $value");
    freetextMessageSend.clear();
  });
  freetextMessageSendContainer.append(freetextMessageSend.renderElement);

  // Tag
  tagContainer.append(ParagraphElement()
    ..innerText = 'Display only tag'
    ..className = "mono light");
  var displayTag = TagView('Display tag value', 'display-tag', selectable: false);
  tagContainer.append(displayTag.renderElement);

  tagContainer.append(ParagraphElement()
    ..innerText = 'Selectable tag'
    ..className = "mono light");
  var selectableTag = TagView('Select tag value', 'select-tag', selectable: true);
  selectableTag.onSelect = () {
    window.alert('Request to select select-tag');
  };
  tagContainer.append(selectableTag.renderElement);

  tagContainer.append(ParagraphElement()
    ..innerText = 'Editable, deletable tag, double click to edit'
    ..className = "mono light");
  var editDelTag = TagView('Edit, delete tag value', 'edit-del-tag', editable: true, deletable: true);
  editDelTag.onEdit = (value) {
    window.alert('Request to edit with new value: $value');
  };
  editDelTag.onDelete = () {
    window.alert('Request to delete edit-del-tag');
  };
  tagContainer.append(editDelTag.renderElement);

  tagContainer.append(ParagraphElement()
    ..innerText = 'Suggested tag'
    ..className = "mono light");
  var suggestedTag =
      TagView('Suggested tag value', 'suggested-tag', suggested: true, acceptable: true, deletable: true);
  suggestedTag.onAccept = () {
    window.alert('Request to accept suggestion: suggested-tag');
  };
  suggestedTag.onDelete = () {
    window.alert('Request to delete: suggested-tag');
  };
  tagContainer.append(suggestedTag.renderElement);

  tagContainer.append(ParagraphElement()
    ..innerText = 'Styles'
    ..className = "mono light");
  var greenTag = TagView('green tag', 'green-tag', tagStyle: TagStyle.Green);
  var yellowTag = TagView('yellow tag', 'yellow-tag', tagStyle: TagStyle.Yellow);
  var redTag = TagView('red tag', 'red-tag', tagStyle: TagStyle.Red);
  var importantTag = TagView('important tag', 'important-tag', tagStyle: TagStyle.Important);
  var pendingTag = TagView('pending tag', 'pending-tag');
  pendingTag.markPending(true);
  var highlightTag = TagView('highlight tag', 'highlight-tag');
  highlightTag.markHighlighted(true);
  tagContainer
    ..append(greenTag.renderElement)
    ..append(yellowTag.renderElement)
    ..append(redTag.renderElement)
    ..append(importantTag.renderElement)
    ..append(pendingTag.renderElement)
    ..append(highlightTag.renderElement);

  tagContainer.append(ParagraphElement()
    ..innerText = 'Add edit on add'
    ..className = "mono light");
  var editAddContainer = DivElement();
  var editAddButton = Button(ButtonType.add, onClick: (_){
    var editOnAddTag =
      TagView('', 'edit-on-add-tag', editable: true, deletable: true);
    editOnAddTag.onEdit = (value) {
      window.alert('Added new tag with value: $value');
    };
    editOnAddTag.onDelete = () {
      editOnAddTag.renderElement.remove();
    };
    editOnAddTag.onCancel = () {
      editOnAddTag.renderElement.remove();
    };

    editAddContainer.append(editOnAddTag.renderElement);
    editOnAddTag.beginEdit();
  });
  tagContainer
    ..append(editAddButton.renderElement)
    ..append(editAddContainer);

  Turnline turnline1 = new Turnline('Demog survey');
  turnline1.addStep(new TurnlineStep('Consent step', true, true));
  turnline1.addStep(new TurnlineStep('Age question', true, true));
  turnline1.addStep(new TurnlineStep('Gener question', true, true));
  turnlinesContainer.append(turnline1.renderElement);

  Turnline turnline2 = new Turnline('Cohort discussion');
  turnline2.addStep(new TurnlineStep('Question 1', true, true));
  turnline2.addStep(new TurnlineStep('Question 2', true, true));
  turnline2.addStep(new TurnlineStep('Question 3', true, false));
  turnline2.addStep(new TurnlineStep('Question 4', false, false));
  turnline2.addStep(new TurnlineStep('Question 5', false, false));
  turnlinesContainer.append(turnline2.renderElement);

  Turnline turnline3 = new Turnline('Feedback');
  turnline3.addStep(new TurnlineStep('Feedback', true, false));
  turnlinesContainer.append(turnline3.renderElement);

  reflowTurnlinesCascade(turnline1);
}

void printURLViewParams(UrlView urlView) {
  logger.debug("Conversation ID: ${urlView.getPageUrlConversationId()}");
  logger.debug("Conversation list ID: ${urlView.getPageUrlConversationList()}");
  logger.debug("Conversation ID filter: ${urlView.getPageUrlFilterConversationId()}");
  logger.debug("Include filter: ${urlView.getPageUrlFilterTags(TagFilterType.include)}");
  logger.debug("Exclude filter: ${urlView.getPageUrlFilterTags(TagFilterType.exclude)}");
  logger.debug("Include after date: ${urlView.getPageUrlFilterAfterDate(TagFilterType.include)}");
  logger.debug("Exclude after date: ${urlView.getPageUrlFilterAfterDate(TagFilterType.exclude)}");
}
