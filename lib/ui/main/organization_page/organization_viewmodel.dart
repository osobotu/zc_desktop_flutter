import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:zc_desktop_flutter/app/app.locator.dart';
import 'package:zc_desktop_flutter/app/app.logger.dart';
import 'package:zc_desktop_flutter/app/app.router.dart';
import 'package:zc_desktop_flutter/models/channels/channels_datamodel.dart';

import 'package:zc_desktop_flutter/models/organization/organization.dart';

import 'package:zc_desktop_flutter/services/channel_service/channels_service.dart';

import 'package:zc_desktop_flutter/services/dm_service/dm_service.dart';
import 'package:zc_desktop_flutter/services/organization/organization_service.dart';

class OrganizationViewModel extends BaseViewModel {
  final log = getLogger("OrganizationViewModel");
  final _navigationService = locator<NavigationService>();
  final _organizationService = locator<OrganizationService>();
  final _channelService = locator<ChannelsService>();
  final _dmService = locator<DMService>();

  ScrollController controller = ScrollController();

  Organization _currentOrganization = Organization();

  bool _showDMs = false;
  bool _showMenus = false;
  bool _showChannels = false;

  List<Organization> _organization = [];
  List<Channel> _channels = [];
  //List<DM> _directMessages = [];

  List<Organization> get organization => _organization;
  List<Channel> get channels => _channels;
  //List<DM> get directMessages => _directMessages;

  Organization? get currentOrganization => _currentOrganization;

  bool get showDMs => _showDMs;
  bool get showMenus => _showMenus;
  bool get showChannels => _showChannels;

  void setup() {
    setSelectedOrganization(0);
    setupOrganization();
    log.i(_currentOrganization);
    log.i(_channels);
  }

  void reloadWithSelectedOrganization(int index) {
    log.i(
        "current selected organization index ${getSelectedOrganizationIndex()} and index to change to $index");
    if (index != getSelectedOrganizationIndex().toInt()) {
      setupOrganization();
      setSelectedOrganization(index);
      _currentOrganization = organization[getSelectedOrganizationIndex()];
    }
    log.i(_currentOrganization);
    return;
  }

  /// called in the view on organization tapped
  void setSelectedOrganization(int index) {
    _organizationService.changeSelectedOrganization(index);
  }

  int getSelectedOrganizationIndex() {
    return _organizationService.selectedOrganization;
  }

  void setupOrganization() async {
    await runBusyFuture(runTask());
    try {
      _currentOrganization = organization[getSelectedOrganizationIndex()];
    } catch (e) {
      log.i(e);
    }
  }

  Future<void> runTask() async {
    _organization =
        await runBusyFuture(_organizationService.getOrganizations());
    // pass orga
    _channels = await runBusyFuture(
        _channelService.getChannelsList(_currentOrganization.id!));
  }

  void openChannelsList() {
    _navigationService.navigateTo(OrganizationViewRoutes.channelsDisplayView,
        id: 1);
  }

  void openChannelsDropDownMenu() {
    _showChannels = !_showChannels;
    notifyListeners();
  }

  void openDMsDropDownMenu() {
    _showDMs = !_showDMs;
    notifyListeners();
  }

  // TODO: go to workspace creation page
  void goToCreateWorkspace() {
    _navigationService.navigateTo(Routes.createWorkspaceView);
  }

  void goToChannelsView(int index) {
    //_channelService.setChannel(_channels[index]);
    _navigationService.navigateTo(OrganizationViewRoutes.channelsView, id: 1);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

/*void setup() async {
    await setupWorkspace();
  }

  void setCurrentWorkspaceIndex(int index) {
    log.i("$index from workspace");
    currentWorkspaceIndex = index;
    setupWorkspace();
    notifyListeners();
  }

  //TODO: ontap workspace, get workspaces
  Future setupWorkspace() async {
    await runBusyFuture(runTask());
  }

  // get workspaces
  Future<void> runTask() async {
    _workspace = await _workspaceService.getWorkspaces();
    getChannels();
    getUsers();
  }

  void getChannels() {
    if (_workspace.isNotEmpty) {
      _channels = _workspace[currentWorkspaceIndex].channels!;
    }
    notifyListeners();
  }

  void getUsers() {
    if (_workspace.isNotEmpty) {
      _directMessages = _workspace[currentWorkspaceIndex].dms!;
    }
    notifyListeners();
  }

  void goToDmView(int index) {
    _dmService.setUser(_directMessages[index].user!);
    _navigationService.navigateTo(WorkspaceViewRoutes.dmView, id: 1);
  }

  void goToChannelsView(int index) {
    _channelService.setChannel(_channels[index]);
    _navigationService.navigateTo(WorkspaceViewRoutes.channelsView, id: 1);
  }

  String? getWorkspaceName() {
    if (_workspace.isNotEmpty) {
      return _workspace[currentWorkspaceIndex].name!;
    }
    notifyListeners();
  }*/
