import 'dart:html';
import 'package:katikati_ui_lib/components/nav/nav_header.dart';
import 'package:katikati_ui_lib/components/snackbar/snackbar.dart';
import 'package:katikati_ui_lib/components/banner/banner.dart';
import 'package:katikati_ui_lib/components/auth/auth.dart' as auth;
import 'package:katikati_ui_lib/components/auth/auth_header.dart';
import 'package:katikati_ui_lib/components/brand_asset/brand_asset.dart' as brand;
import 'package:katikati_ui_lib/components/url_view/url_view.dart';
import 'package:katikati_ui_lib/components/editable/editable_text.dart';
import 'package:katikati_ui_lib/components/conversation/conversation_item.dart';
import 'package:katikati_ui_lib/components/messages/freetext_message_send.dart';
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
DivElement freetextMessageSendContainer = querySelector('#freetext-message-send--wrapper');

DivElement conversationItemsContainer = querySelector('#conversation-items-wrapper');
DivElement conversationItemSimulateContainer = querySelector('#conversation-items-wrapper-simulate');
ButtonElement conversationSimulateSelect = querySelector('#conversation-item-simulate-select');
ButtonElement conversationSimulateUnselect = querySelector('#conversation-item-simulate-unselect');
ButtonElement conversationSimulateCheck = querySelector('#conversation-item-simulate-check');
ButtonElement conversationSimulateUncheck = querySelector('#conversation-item-simulate-uncheck');
ButtonElement conversationSimulateNormal = querySelector('#conversation-item-simulate-normal');
ButtonElement conversationSimulateFailed = querySelector('#conversation-item-simulate-failed');
ButtonElement conversationSimulatePending = querySelector('#conversation-item-simulate-pending');
ButtonElement conversationSimulateDraft = querySelector('#conversation-item-simulate-draft');

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
    authHeaderView.signIn("Username", "assets/profile.png");
  });
  authHeaderSimulateSignOutTrigger.onClick.listen((_) {
    authHeaderView.signOut();
  });

  // nav header
  NavHeaderView navHeaderView = NavHeaderView();
  navHeaderViewContainer.append(navHeaderView.navViewElement);
  navHeaderView.projectLogos = ["assets/logo.png"];
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
  var textEditable = TextEditableView("text")
    ..onChange.listen((value) {
      window.alert("New text: ${value}");
    })
    ..onDelete.listen((_) {
      window.alert("Requesting delete...");
    });
  editableTextContainer.append(textEditable.renderElement);
  var textEditableDefault = TextEditableView("", editableOnAdd: true)
    ..onChange.listen((value) {
      window.alert("New text: ${value}");
    })
    ..onDelete.listen((_) {
      window.alert("Requesting delete...");
    });
  editableTextContainer.append(textEditableDefault.renderElement);

  // Conversation items
  var conversationItem = ConversationItemView(
      "000cbc0c", "Hello, this is an example preview message that is long", ConversationItemStatus.normal,
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

  var conversationDraft = ConversationItemView(
      "000cbc0c", "Hello, this is an example preview message that is long", ConversationItemStatus.draft);
  conversationItemsContainer.append(conversationDraft.renderElement);

  var conversationPending = ConversationItemView(
      "000cbc0c", "Hello, this is an example preview message that is long", ConversationItemStatus.pending);
  conversationItemsContainer.append(conversationPending.renderElement);

  var conversationFailed = ConversationItemView(
      "000cbc0c", "Hello, this is an example preview message that is long", ConversationItemStatus.failed);
  conversationItemsContainer.append(conversationFailed.renderElement);

  var conversationSimulateItem = ConversationItemView(
      "simulate_id", "Hello, this is an example preview message that is long", ConversationItemStatus.normal);
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

  // Freetext message send
  var freetextMessageSend = FreetextMessageSendView("Default text");
  freetextMessageSend.onSend.listen((value) {
    window.alert("Sending: $value");
    freetextMessageSend.clear();
  });
  freetextMessageSendContainer.append(freetextMessageSend.renderElement);
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
