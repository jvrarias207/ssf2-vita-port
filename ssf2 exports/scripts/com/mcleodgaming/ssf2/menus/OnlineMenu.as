package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import com.mcleodgaming.mgn.net.ProtocolSetting;
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.ComboBox;
   import fl.controls.DataGrid;
   import fl.controls.ScrollPolicy;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   public class OnlineMenu extends Menu
   {
      
      private var m_loginNode:MenuMapperNode;
      
      private var m_joinNode:MenuMapperNode;
      
      private var m_createNode:MenuMapperNode;
      
      private var m_battleTypeFilter:String;
      
      private var m_itemsFilter:String;
      
      private var m_hazardsFilter:String;
      
      private var m_friendsFilter:String;
      
      private var m_usernameFocus:Boolean;
      
      private var m_makeRoomFocus:Boolean;
      
      private var m_roomList:DataGrid;
      
      private var m_protocolDropDown:ComboBox;
      
      private var m_bufferDropdown:ComboBox;
      
      private var m_battleTypeDropdown:ComboBox;
      
      private var m_itemsDropdown:ComboBox;
      
      private var m_hazardsDropdown:ComboBox;
      
      private var m_friendsDropdown:ComboBox;
      
      private var m_roomCapacityDropdown:ComboBox;
      
      private var m_requestToJoinRoomTimeout:Timer;
      
      private var m_previousScroll:Number;
      
      private var m_udpIPLabel:TextField;
      
      private var m_udpPortLabel:TextField;
      
      private var m_tcpIPLabel:TextField;
      
      private var m_tcpPortLabel:TextField;
      
      private var m_udpIP:TextField;
      
      private var m_udpPort:TextField;
      
      private var m_tcpIP:TextField;
      
      private var m_tcpPort:TextField;
      
      public function OnlineMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_online");
         m_backgroundID = "space";
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_makeroom.visible = false;
         m_subMenu.online_joinroom.visible = false;
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         this.m_battleTypeFilter = "n/a";
         this.m_itemsFilter = "n/a";
         this.m_hazardsFilter = "n/a";
         this.m_friendsFilter = "no";
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_roomList = m_subMenu.roomList;
         this.m_protocolDropDown = m_subMenu.online_makeroom.latencyDropdown;
         this.m_bufferDropdown = m_subMenu.online_makeroom.bufferDropdown;
         this.m_roomCapacityDropdown = m_subMenu.online_makeroom.roomCapacityDropdown;
         this.m_battleTypeDropdown = m_subMenu.online_filter.battleTypeDropdown;
         this.m_itemsDropdown = m_subMenu.online_filter.itemsDropdown;
         this.m_hazardsDropdown = m_subMenu.online_filter.hazardsDropdown;
         this.m_friendsDropdown = m_subMenu.online_filter.friendsDropdown;
         this.m_usernameFocus = false;
         this.m_makeRoomFocus = false;
         m_subMenu.username_txt.tabIndex = 1;
         m_subMenu.password_txt.tabIndex = 2;
         m_subMenu.username_txt.tabEnabled = true;
         m_subMenu.password_txt.tabEnabled = true;
         this.m_roomList.addColumn("Room");
         this.m_roomList.addColumn("Private");
         this.m_roomList.addColumn("Creator");
         this.m_roomList.addColumn("Location");
         this.m_roomList.addColumn("Players");
         this.m_roomList.addColumn("Latency");
         this.m_roomList.addColumn("Ping");
         this.m_roomList.getColumnAt(1).width = 50;
         this.m_roomList.getColumnAt(2).width = 90;
         this.m_roomList.getColumnAt(3).width = 125;
         this.m_roomList.getColumnAt(4).width = 50;
         this.m_roomList.getColumnAt(5).width = 65;
         this.m_roomList.getColumnAt(6).width = 50;
         this.m_previousScroll = this.m_roomList.verticalScrollPosition;
         this.m_protocolDropDown.addItem({
            "label":"Auto",
            "value":ProtocolSetting.P2P_RTMFP
         });
         this.m_protocolDropDown.addItem({
            "label":"High",
            "value":ProtocolSetting.CLIENT_SERVER_TCP
         });
         this.m_bufferDropdown.addItem({
            "label":"Auto",
            "value":0
         });
         this.m_bufferDropdown.addItem({
            "label":"Low",
            "value":2
         });
         this.m_bufferDropdown.addItem({
            "label":"Normal",
            "value":3
         });
         this.m_bufferDropdown.addItem({
            "label":"High",
            "value":4
         });
         this.m_bufferDropdown.selectedItem = this.m_bufferDropdown.getItemAt(2);
         this.m_battleTypeDropdown.addItem({
            "label":"N/A",
            "value":"n/a"
         });
         this.m_battleTypeDropdown.addItem({
            "label":"Stock Only",
            "value":"stock"
         });
         this.m_battleTypeDropdown.addItem({
            "label":"Time Only",
            "value":"time"
         });
         this.m_battleTypeDropdown.addItem({
            "label":"Stock + Time",
            "value":"stocktime"
         });
         this.m_itemsDropdown.addItem({
            "label":"N/A",
            "value":"n/a"
         });
         this.m_itemsDropdown.addItem({
            "label":"On",
            "value":"on"
         });
         this.m_itemsDropdown.addItem({
            "label":"Off",
            "value":"off"
         });
         this.m_hazardsDropdown.addItem({
            "label":"N/A",
            "value":"n/a"
         });
         this.m_hazardsDropdown.addItem({
            "label":"On",
            "value":"on"
         });
         this.m_hazardsDropdown.addItem({
            "label":"Off",
            "value":"off"
         });
         this.m_friendsDropdown.addItem({
            "label":"No",
            "value":"no"
         });
         this.m_friendsDropdown.addItem({
            "label":"Yes",
            "value":"yes"
         });
         this.m_roomCapacityDropdown.addItem({
            "label":"2",
            "value":2
         });
         this.m_roomCapacityDropdown.addItem({
            "label":"3",
            "value":3
         });
         this.m_roomCapacityDropdown.addItem({
            "label":"4",
            "value":4
         });
         this.m_roomCapacityDropdown.selectedIndex = 0;
         this.hideAllButtons();
         this.m_requestToJoinRoomTimeout = new Timer(20000);
         this.m_requestToJoinRoomTimeout.addEventListener(TimerEvent.TIMER,this.onRequestToJoinRoomTimeout);
         if(Main.DEBUG)
         {
            this.m_udpIPLabel = new TextField();
            this.m_udpPortLabel = new TextField();
            this.m_tcpIPLabel = new TextField();
            this.m_tcpPortLabel = new TextField();
            this.m_udpIPLabel.text = "UDP IP:";
            this.m_udpIPLabel.x = 138;
            this.m_udpIPLabel.y = -22;
            this.m_udpIPLabel.width = 60;
            this.m_udpIPLabel.height = 20;
            this.m_udpIPLabel.setTextFormat(new TextFormat(null,12,16777215,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_udpIPLabel.background = true;
            this.m_udpIPLabel.backgroundColor = 0;
            this.m_udpPortLabel.text = "UDP Port:";
            this.m_udpPortLabel.x = 138;
            this.m_udpPortLabel.y = -7;
            this.m_udpPortLabel.width = 60;
            this.m_udpPortLabel.height = 20;
            this.m_udpPortLabel.setTextFormat(new TextFormat(null,12,16777215,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_udpPortLabel.background = true;
            this.m_udpPortLabel.backgroundColor = 0;
            this.m_tcpIPLabel.text = "TCP IP:";
            this.m_tcpIPLabel.x = 138;
            this.m_tcpIPLabel.y = 12;
            this.m_tcpIPLabel.width = 60;
            this.m_tcpIPLabel.height = 20;
            this.m_tcpIPLabel.setTextFormat(new TextFormat(null,12,16777215,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_tcpIPLabel.background = true;
            this.m_tcpIPLabel.backgroundColor = 0;
            this.m_tcpPortLabel.text = "TCP Port:";
            this.m_tcpPortLabel.x = 138;
            this.m_tcpPortLabel.y = 27;
            this.m_tcpPortLabel.width = 60;
            this.m_tcpPortLabel.height = 20;
            this.m_tcpPortLabel.setTextFormat(new TextFormat(null,12,16777215,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_tcpPortLabel.background = true;
            this.m_tcpPortLabel.backgroundColor = 0;
            this.m_udpIP = new TextField();
            this.m_udpPort = new TextField();
            this.m_tcpIP = new TextField();
            this.m_tcpPort = new TextField();
            this.m_udpIP.type = TextFieldType.INPUT;
            this.m_udpIP.x = 200;
            this.m_udpIP.y = -22;
            this.m_udpIP.width = 100;
            this.m_udpIP.height = 20;
            this.m_udpIP.setTextFormat(new TextFormat(null,12,0,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_udpIP.background = true;
            this.m_udpIP.backgroundColor = 16777215;
            this.m_udpIP.addEventListener(Event.CHANGE,this.onUDPIPChanged);
            this.m_udpPort.type = TextFieldType.INPUT;
            this.m_udpPort.x = 200;
            this.m_udpPort.y = -7;
            this.m_udpPort.width = 100;
            this.m_udpPort.height = 20;
            this.m_udpPort.setTextFormat(new TextFormat(null,12,0,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_udpPort.background = true;
            this.m_udpPort.backgroundColor = 16777215;
            this.m_udpPort.addEventListener(Event.CHANGE,this.onUDPPortChanged);
            this.m_tcpIP.type = TextFieldType.INPUT;
            this.m_tcpIP.x = 200;
            this.m_tcpIP.y = 12;
            this.m_tcpIP.width = 100;
            this.m_tcpIP.height = 20;
            this.m_tcpIP.setTextFormat(new TextFormat(null,12,0,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_tcpIP.background = true;
            this.m_tcpIP.backgroundColor = 16777215;
            this.m_tcpIP.addEventListener(Event.CHANGE,this.onTCPIPChanged);
            this.m_tcpPort.type = TextFieldType.INPUT;
            this.m_tcpPort.x = 200;
            this.m_tcpPort.y = 27;
            this.m_tcpPort.width = 100;
            this.m_tcpPort.height = 20;
            this.m_tcpPort.setTextFormat(new TextFormat(null,12,0,null,null,null,null,null,TextFormatAlign.RIGHT));
            this.m_tcpPort.background = true;
            this.m_tcpPort.backgroundColor = 16777215;
            this.m_tcpPort.addEventListener(Event.CHANGE,this.onTCPPortChanged);
            this.m_udpIP.text = SaveData.getP2PSettings().udpIP;
            this.m_udpPort.text = SaveData.getP2PSettings().udpPort;
            this.m_tcpIP.text = SaveData.getP2PSettings().tcpIP;
            this.m_tcpPort.text = SaveData.getP2PSettings().tcpPort;
            m_subMenu.addChild(this.m_udpIPLabel);
            m_subMenu.addChild(this.m_udpPortLabel);
            m_subMenu.addChild(this.m_tcpIPLabel);
            m_subMenu.addChild(this.m_tcpPortLabel);
            m_subMenu.addChild(this.m_udpIP);
            m_subMenu.addChild(this.m_udpPort);
            m_subMenu.addChild(this.m_tcpIP);
            m_subMenu.addChild(this.m_tcpPort);
         }
      }
      
      private function onUDPIPChanged(e:Event) : void
      {
         var oldSettings:Object = SaveData.getP2PSettings();
         SaveData.setP2PSettings(this.m_udpIP.text,oldSettings.udpPort,oldSettings.tcpIP,oldSettings.tcpPort);
      }
      
      private function onUDPPortChanged(e:Event) : void
      {
         var oldSettings:Object = SaveData.getP2PSettings();
         SaveData.setP2PSettings(oldSettings.udpIP,parseInt(this.m_udpPort.text),oldSettings.tcpIP,oldSettings.tcpPort);
      }
      
      private function onTCPIPChanged(e:Event) : void
      {
         var oldSettings:Object = SaveData.getP2PSettings();
         SaveData.setP2PSettings(oldSettings.udpIP,oldSettings.udpPort,this.m_tcpIP.text,oldSettings.tcpPort);
      }
      
      private function onTCPPortChanged(e:Event) : void
      {
         var oldSettings:Object = SaveData.getP2PSettings();
         SaveData.setP2PSettings(oldSettings.udpIP,oldSettings.udpPort,oldSettings.tcpIP,parseInt(this.m_tcpPort.text));
      }
      
      override public function manageMenuMappings(e:Event) : void
      {
         if(this.m_makeRoomFocus || this.m_usernameFocus)
         {
            return;
         }
         super.manageMenuMappings(e);
      }
      
      override public function initMenuMappings() : void
      {
         super.initMenuMappings();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.loginBG.register_btn.buttonMode = true;
         m_subMenu.loginBG.register_btn.useHandCursor = true;
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_online);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_online);
         m_subMenu.online_makeroom.createRoom_txt.addEventListener(FocusEvent.FOCUS_IN,this.makeRoom_FOCUS);
         m_subMenu.username_txt.addEventListener(FocusEvent.FOCUS_IN,this.username_FOCUS);
         m_subMenu.online_makeroom.createRoom_txt.addEventListener(FocusEvent.FOCUS_OUT,this.makeRoom_FOCUS);
         m_subMenu.username_txt.addEventListener(FocusEvent.FOCUS_OUT,this.username_UNFOCUS);
         m_subMenu.username_txt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         m_subMenu.password_txt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         m_subMenu.login_btn.addEventListener(MouseEvent.MOUSE_OVER,this.login_MOUSE_OVER);
         m_subMenu.login_btn.addEventListener(MouseEvent.MOUSE_OUT,this.login_MOUSE_OUT);
         m_subMenu.login_btn.addEventListener(MouseEvent.CLICK,this.login_CLICK);
         m_subMenu.loginBG.register_btn.addEventListener(MouseEvent.CLICK,this.register_CLICK);
         m_subMenu.refresh_btn.addEventListener(MouseEvent.MOUSE_OVER,this.refresh_MOUSE_OVER);
         m_subMenu.refresh_btn.addEventListener(MouseEvent.MOUSE_OUT,this.refresh_MOUSE_OUT);
         m_subMenu.refresh_btn.addEventListener(MouseEvent.CLICK,this.refresh_CLICK);
         m_subMenu.join_btn.addEventListener(MouseEvent.MOUSE_OVER,this.join_MOUSE_OVER);
         m_subMenu.join_btn.addEventListener(MouseEvent.MOUSE_OUT,this.join_MOUSE_OUT);
         m_subMenu.join_btn.addEventListener(MouseEvent.CLICK,this.join_CLICK);
         m_subMenu.logout_btn.addEventListener(MouseEvent.MOUSE_OVER,this.logout_MOUSE_OVER);
         m_subMenu.logout_btn.addEventListener(MouseEvent.MOUSE_OUT,this.logout_MOUSE_OUT);
         m_subMenu.logout_btn.addEventListener(MouseEvent.CLICK,this.logout_CLICK);
         m_subMenu.filter_btn.addEventListener(MouseEvent.MOUSE_OVER,this.filter_MOUSE_OVER);
         m_subMenu.filter_btn.addEventListener(MouseEvent.MOUSE_OUT,this.filter_MOUSE_OUT);
         m_subMenu.filter_btn.addEventListener(MouseEvent.CLICK,this.filter_CLICK);
         m_subMenu.online_makeroom.createRoom_btn.addEventListener(MouseEvent.MOUSE_OVER,this.createRoom_MOUSE_OVER);
         m_subMenu.online_makeroom.createRoom_btn.addEventListener(MouseEvent.MOUSE_OUT,this.createRoom_MOUSE_OUT);
         m_subMenu.online_makeroom.createRoom_btn.addEventListener(MouseEvent.CLICK,this.createRoom_CLICK);
         m_subMenu.online_joinroom.joinRoom_btn.addEventListener(MouseEvent.MOUSE_OVER,this.joinRoomPassword_MOUSE_OVER);
         m_subMenu.online_joinroom.joinRoom_btn.addEventListener(MouseEvent.MOUSE_OUT,this.joinRoomPassword_MOUSE_OUT);
         m_subMenu.online_joinroom.joinRoom_btn.addEventListener(MouseEvent.CLICK,this.joinRoomPassword_CLICK);
         m_subMenu.online_filter.close_btn.addEventListener(MouseEvent.CLICK,this.filterClose_CLICK);
         m_subMenu.createRoom_btn.addEventListener(MouseEvent.MOUSE_OVER,this.createRoomPopup_MOUSE_OVER);
         m_subMenu.createRoom_btn.addEventListener(MouseEvent.MOUSE_OUT,this.createRoomPopup_MOUSE_OUT);
         m_subMenu.createRoom_btn.addEventListener(MouseEvent.CLICK,this.createRoomPopup_CLICK);
         m_subMenu.online_makeroom.close_btn.addEventListener(MouseEvent.CLICK,this.createRoomClose_CLICK);
         m_subMenu.online_joinroom.close_btn.addEventListener(MouseEvent.CLICK,this.joinRoomPasswordClose_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.CONNECT,this.onConnect);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.DISCONNECT,this.onDisconnect);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LOGIN,this.onLogin);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_CREATED,this.onCreateRoom);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_JOINED,this.onJoinRoom);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LOGIN,this.onLoginError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_CREATE_ROOM,this.onCreateRoomError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_REQUEST_TO_JOIN_ROOM,this.onRoomJoinRequestError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_JOIN_ROOM,this.onJoinRoomError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_CONNECT,this.onConnectError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_OFFLINE,this.onConnectError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_LIST,this.onRefreshRoomList);
         if(MultiplayerManager.Connected)
         {
            this.showRoomList();
         }
         else
         {
            this.showLoginButtons();
         }
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode === Key.ENTER)
         {
            this.login_CLICK(null);
         }
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_online);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_online);
         m_subMenu.online_makeroom.createRoom_txt.removeEventListener(FocusEvent.FOCUS_IN,this.makeRoom_FOCUS);
         m_subMenu.username_txt.removeEventListener(FocusEvent.FOCUS_IN,this.username_FOCUS);
         m_subMenu.online_makeroom.createRoom_txt.removeEventListener(FocusEvent.FOCUS_OUT,this.makeRoom_FOCUS);
         m_subMenu.username_txt.removeEventListener(FocusEvent.FOCUS_OUT,this.username_UNFOCUS);
         m_subMenu.username_txt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         m_subMenu.password_txt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         m_subMenu.login_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.login_MOUSE_OVER);
         m_subMenu.login_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.login_MOUSE_OUT);
         m_subMenu.login_btn.removeEventListener(MouseEvent.CLICK,this.login_CLICK);
         m_subMenu.loginBG.register_btn.removeEventListener(MouseEvent.CLICK,this.register_CLICK);
         m_subMenu.refresh_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.refresh_MOUSE_OVER);
         m_subMenu.refresh_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.refresh_MOUSE_OUT);
         m_subMenu.refresh_btn.removeEventListener(MouseEvent.CLICK,this.refresh_CLICK);
         m_subMenu.join_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.join_MOUSE_OVER);
         m_subMenu.join_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.join_MOUSE_OUT);
         m_subMenu.join_btn.removeEventListener(MouseEvent.CLICK,this.join_CLICK);
         m_subMenu.logout_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.logout_MOUSE_OVER);
         m_subMenu.logout_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.logout_MOUSE_OUT);
         m_subMenu.logout_btn.removeEventListener(MouseEvent.CLICK,this.logout_CLICK);
         m_subMenu.filter_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.filter_MOUSE_OVER);
         m_subMenu.filter_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.filter_MOUSE_OUT);
         m_subMenu.filter_btn.removeEventListener(MouseEvent.CLICK,this.filter_CLICK);
         m_subMenu.online_makeroom.createRoom_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.createRoom_MOUSE_OVER);
         m_subMenu.online_makeroom.createRoom_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.createRoom_MOUSE_OUT);
         m_subMenu.online_makeroom.createRoom_btn.removeEventListener(MouseEvent.CLICK,this.createRoom_CLICK);
         m_subMenu.online_joinroom.joinRoom_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.joinRoomPassword_MOUSE_OVER);
         m_subMenu.online_joinroom.joinRoom_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.joinRoomPassword_MOUSE_OUT);
         m_subMenu.online_joinroom.joinRoom_btn.removeEventListener(MouseEvent.CLICK,this.joinRoomPassword_CLICK);
         m_subMenu.online_filter.close_btn.removeEventListener(MouseEvent.CLICK,this.filterClose_CLICK);
         m_subMenu.createRoom_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.createRoomPopup_MOUSE_OVER);
         m_subMenu.createRoom_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.createRoomPopup_MOUSE_OUT);
         m_subMenu.createRoom_btn.removeEventListener(MouseEvent.CLICK,this.createRoomPopup_CLICK);
         m_subMenu.online_makeroom.close_btn.removeEventListener(MouseEvent.CLICK,this.createRoomClose_CLICK);
         m_subMenu.online_joinroom.close_btn.removeEventListener(MouseEvent.CLICK,this.joinRoomPasswordClose_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.CONNECT,this.onConnect);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.DISCONNECT,this.onDisconnect);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.LOGIN,this.onLogin);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_CREATED,this.onCreateRoom);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_JOINED,this.onJoinRoom);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_LOGIN,this.onLoginError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_CREATE_ROOM,this.onCreateRoomError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_REQUEST_TO_JOIN_ROOM,this.onRoomJoinRequestError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_JOIN_ROOM,this.onJoinRoomError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_CONNECT,this.onConnectError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_OFFLINE,this.onConnectError);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_LIST,this.onRefreshRoomList);
         this.m_requestToJoinRoomTimeout.reset();
         m_subMenu.username_txt.text = "";
         m_subMenu.password_txt.text = "";
      }
      
      private function hideAllButtons() : void
      {
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_makeroom.visible = false;
         m_subMenu.online_joinroom.visible = false;
         m_subMenu.online_filter.visible = false;
         m_subMenu.username_txt.visible = false;
         m_subMenu.password_txt.visible = false;
         m_subMenu.loginBG.visible = false;
         m_subMenu.login_btn.visible = false;
         m_subMenu.roomListBG.visible = false;
         m_subMenu.roomList.visible = false;
         m_subMenu.createRoom_btn.visible = false;
         m_subMenu.join_btn.visible = false;
         m_subMenu.refresh_btn.visible = false;
         m_subMenu.filter_btn.visible = false;
         m_subMenu.logout_btn.visible = false;
      }
      
      private function showLoginButtons() : void
      {
         this.hideAllButtons();
         Utils.setBrightness(m_subMenu.loginBG,0);
         m_subMenu.username_txt.type = TextFieldType.INPUT;
         m_subMenu.password_txt.type = TextFieldType.INPUT;
         m_subMenu.loginBG.visible = true;
         m_subMenu.login_btn.visible = true;
         m_subMenu.username_txt.visible = true;
         m_subMenu.password_txt.visible = true;
         if(Boolean(SaveData.RememberMe))
         {
            m_subMenu.username_txt.text = SaveData.RememberMe;
            m_subMenu.loginBG.rememberMe.selected = true;
         }
         else
         {
            m_subMenu.loginBG.rememberMe.selected = false;
         }
      }
      
      private function showRoomList() : void
      {
         this.hideAllButtons();
         m_subMenu.roomListBG.visible = true;
         m_subMenu.roomList.visible = true;
         m_subMenu.createRoom_btn.visible = true;
         m_subMenu.join_btn.visible = true;
         m_subMenu.refresh_btn.visible = true;
         m_subMenu.filter_btn.visible = true;
         m_subMenu.logout_btn.visible = true;
      }
      
      private function makeRoom_FOCUS(e:FocusEvent) : void
      {
         this.m_makeRoomFocus = true;
      }
      
      private function makeRoom_UNFOCUS(e:FocusEvent) : void
      {
         this.m_makeRoomFocus = false;
      }
      
      private function username_FOCUS(e:FocusEvent) : void
      {
         this.m_usernameFocus = true;
      }
      
      private function username_UNFOCUS(e:FocusEvent) : void
      {
         this.m_usernameFocus = false;
      }
      
      private function login_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Click to log on.";
      }
      
      private function login_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function register_CLICK(e:MouseEvent) : void
      {
         var url:String = "http://mgn.mcleodgaming.com/account/register";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function login_CLICK(e:MouseEvent) : void
      {
         var password:String = null;
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.desc_txt.text = "";
         if(!MultiplayerManager.Connected)
         {
            password = m_subMenu.password_txt.text;
            m_subMenu.login_btn.visible = false;
            m_subMenu.username_txt.type = TextFieldType.DYNAMIC;
            m_subMenu.password_txt.type = TextFieldType.DYNAMIC;
            Utils.setBrightness(m_subMenu.loginBG,-50);
            MultiplayerManager.connect(m_subMenu.username_txt.text,password,Version.getVersion());
            m_subMenu.password_txt.text = "";
            if(Boolean(m_subMenu.loginBG.rememberMe.selected))
            {
               SaveData.RememberMe = m_subMenu.username_txt.text;
               SaveData.saveGame();
            }
            else
            {
               SaveData.RememberMe = null;
               SaveData.saveGame();
            }
         }
      }
      
      private function refresh_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Refresh list of rooms.";
      }
      
      private function refresh_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function refresh_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         this.refreshRoomsList();
      }
      
      public function refreshRoomsList() : void
      {
         this.m_previousScroll = this.m_roomList.verticalScrollPosition;
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.refreshRoomList(this.m_friendsFilter === "yes");
         }
      }
      
      private function onRequestToJoinRoomTimeout(e:TimerEvent) : void
      {
         this.m_requestToJoinRoomTimeout.stop();
         MultiplayerManager.notify("Room join request timed out. Please try again.");
         MenuController.pleaseWaitMenu.removeSelf();
         m_container.visible = true;
         this.refreshRoomsList();
      }
      
      private function onRefreshRoomList(e:MGNEvent) : void
      {
         this.populateRoomList(e.data.rooms);
         this.m_roomList.verticalScrollPosition = this.m_previousScroll;
      }
      
      private function onLogin(e:MGNEvent) : void
      {
         this.refreshRoomsList();
         this.showRoomList();
         MultiplayerManager.ping();
         if(Main.LOCALHOST)
         {
            Main.tracker.event("SSF2 Local Online","login",Version.getVersion());
         }
         else
         {
            Main.tracker.event("SSF2 Web Online","login",Version.getVersion());
         }
      }
      
      private function onLoginError(e:MGNEvent) : void
      {
         this.showLoginButtons();
      }
      
      private function onConnect(e:MGNEvent) : void
      {
         trace("Connection complete (inside online menu)");
      }
      
      private function onConnectError(e:MGNEvent) : void
      {
         trace("Some error has occured while connecting (inside online menu)");
         this.showLoginButtons();
      }
      
      private function onDisconnect(e:MGNEvent) : void
      {
         this.showLoginButtons();
      }
      
      private function onCreateRoom(e:MGNEvent) : void
      {
         MenuController.pleaseWaitMenu.removeSelf();
         removeSelf();
         m_container.visible = true;
         MenuController.onlineGroupMenu.show();
      }
      
      private function onCreateRoomError(e:MGNEvent) : void
      {
         MenuController.pleaseWaitMenu.removeSelf();
         m_container.visible = true;
         this.refreshRoomsList();
      }
      
      private function onJoinRoom(e:MGNEvent) : void
      {
         removeSelf();
         m_container.visible = true;
         MenuController.pleaseWaitMenu.removeSelf();
         MenuController.CurrentCharacterSelectMenu = MenuController.onlineCharacterMenu;
         MenuController.onlineCharacterMenu.reset();
         MenuController.onlineCharacterMenu.show();
         this.m_roomList.removeAll();
      }
      
      private function onRoomJoinRequestError(e:MGNEvent) : void
      {
         this.m_requestToJoinRoomTimeout.stop();
         MenuController.pleaseWaitMenu.removeSelf();
         m_container.visible = true;
         this.refreshRoomsList();
      }
      
      private function onJoinRoomError(e:MGNEvent) : void
      {
         this.m_requestToJoinRoomTimeout.stop();
         MenuController.pleaseWaitMenu.removeSelf();
         m_container.visible = true;
      }
      
      private function populateRoomList(rooms:Array) : void
      {
         var i:* = undefined;
         var roomData:Object = null;
         var creator:String = null;
         var location:String = null;
         var players:String = null;
         var ping:String = null;
         var priv:String = null;
         var hasPass:Boolean = false;
         var protocol:String = null;
         if(this.m_roomList != null)
         {
            this.m_roomList.removeAll();
            this.m_roomList.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_roomList.verticalScrollPolicy = ScrollPolicy.ON;
            for(i in rooms)
            {
               roomData = null;
               try
               {
                  roomData = JSON.parse(rooms[i].room_data);
               }
               catch(e:*)
               {
                  roomData = {"version":null};
               }
               if(roomData.version === Version.getVersion())
               {
                  if(Boolean(this.m_battleTypeFilter === "stock") && Boolean(roomData.matchSettings.levelData.usingTime) || Boolean(this.m_battleTypeFilter === "time") && Boolean(roomData.matchSettings.levelData.usingLives) || this.m_battleTypeFilter === "stocktime" && (!roomData.matchSettings.levelData.usingTime || !roomData.matchSettings.levelData.usingLives))
                  {
                     continue;
                  }
                  if(this.m_hazardsFilter === "on" && !roomData.matchSettings.levelData.hazards || Boolean(this.m_hazardsFilter === "off") && Boolean(roomData.matchSettings.levelData.hazards))
                  {
                     continue;
                  }
                  if(this.m_itemsFilter === "on" && !(roomData.matchSettings.items.frequency !== ItemSettings.FREQUENCY_OFF && this.activeItemCount(roomData.matchSettings.items.items) > 0) || this.m_itemsFilter === "off" && (roomData.matchSettings.items.frequency !== ItemSettings.FREQUENCY_OFF && this.activeItemCount(roomData.matchSettings.items.items) > 0))
                  {
                     continue;
                  }
                  if(rooms[i].room_locked == 1)
                  {
                     continue;
                  }
                  creator = Boolean(rooms[i].is_dev) ? "+ " + rooms[i].creator : rooms[i].creator;
                  location = CountryRegionData.getLocationClean(rooms[i].country,rooms[i].region);
                  players = rooms[i].room_total + "/" + rooms[i].room_max;
                  protocol = roomData.protocol === ProtocolSetting.P2P_RTMFP ? "Auto" : "High";
                  ping = Boolean(rooms[i].ping_average) ? rooms[i].ping_average + "ms" : "...";
                  priv = rooms[i].hasPassword == 1 ? "X" : "";
                  hasPass = rooms[i].hasPassword == 1 ? true : false;
                  this.m_roomList.addItem({
                     "Room":rooms[i].room_name,
                     "Creator":creator,
                     "Location":location,
                     "Players":players,
                     "room_key":rooms[i].room_key,
                     "room_name":rooms[i].room_name,
                     "Protocol":protocol,
                     "Ping":ping,
                     "Private":priv,
                     "hasPassword":hasPass
                  });
               }
               roomData = null;
            }
            if(this.m_roomList.sortIndex >= 0)
            {
               this.m_roomList.sortItemsOn(this.m_roomList.getColumnAt(this.m_roomList.sortIndex).headerText,Array.CASEINSENSITIVE | (!this.m_roomList.sortDescending ? Array.DESCENDING : 0));
            }
         }
      }
      
      private function activeItemCount(obj:Object) : int
      {
         var i:* = undefined;
         var total:int = 0;
         for(i in obj)
         {
            if(obj[i] === true)
            {
               total++;
            }
         }
         return total;
      }
      
      private function logout_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Sign out of your account.";
      }
      
      private function logout_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function logout_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         MultiplayerManager.disconnect();
         this.showLoginButtons();
      }
      
      private function filter_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Narrow down your search for a room.";
      }
      
      private function filter_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function filter_CLICK(e:MouseEvent) : void
      {
         this.setSelectedItem(this.m_battleTypeDropdown,this.m_battleTypeFilter);
         this.setSelectedItem(this.m_itemsDropdown,this.m_itemsFilter);
         this.setSelectedItem(this.m_hazardsDropdown,this.m_hazardsFilter);
         this.setSelectedItem(this.m_friendsDropdown,this.m_friendsFilter);
         this.setSelectedItem(this.m_battleTypeDropdown,this.m_battleTypeFilter);
         m_subMenu.onlinebg.visible = true;
         m_subMenu.online_filter.visible = true;
         SoundQueue.instance.playSoundEffect("menu_selectstage");
      }
      
      private function setSelectedItem(combobox:ComboBox, value:*) : void
      {
         for(var i:int = 0; i < combobox.length; i++)
         {
            if(combobox.getItemAt(i).value === value)
            {
               combobox.selectedIndex = i;
               return;
            }
         }
      }
      
      private function filterClose_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_filter.visible = false;
         this.m_battleTypeFilter = this.m_battleTypeDropdown.selectedItem.value;
         this.m_itemsFilter = this.m_itemsDropdown.selectedItem.value;
         this.m_hazardsFilter = this.m_hazardsDropdown.selectedItem.value;
         this.m_friendsFilter = this.m_friendsDropdown.selectedItem.value;
         this.refreshRoomsList();
      }
      
      private function join_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Click to join match.";
      }
      
      private function join_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function join_CLICK(e:MouseEvent) : void
      {
         if(Boolean(this.m_roomList.length > 0) && Boolean(this.m_roomList.selectedItem) && MultiplayerManager.Connected)
         {
            if(Boolean(this.m_roomList.selectedItem.hasPassword))
            {
               m_subMenu.onlinebg.visible = true;
               m_subMenu.online_joinroom.visible = true;
            }
            else
            {
               this.requestToJoinRoom();
            }
         }
      }
      
      private function joinRoomPassword_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "";
      }
      
      private function joinRoomPassword_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function joinRoomPassword_CLICK(e:MouseEvent) : void
      {
         if(Boolean(this.m_roomList.length > 0) && Boolean(this.m_roomList.selectedItem) && MultiplayerManager.Connected)
         {
            this.requestToJoinRoom();
         }
      }
      
      private function joinRoomPasswordClose_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_joinroom.visible = false;
      }
      
      private function requestToJoinRoom() : void
      {
         SaveData.saveGame();
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_makeroom.visible = false;
         m_subMenu.online_joinroom.visible = false;
         m_container.visible = false;
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.desc_txt.text = "";
         MultiplayerManager.requestToJoinRoom(this.m_roomList.selectedItem.room_key,m_subMenu.online_joinroom.roomPass_txt.text);
         m_subMenu.online_joinroom.roomPass_txt.text = "";
         MenuController.pleaseWaitMenu.show();
         this.m_requestToJoinRoomTimeout.reset();
         this.m_requestToJoinRoomTimeout.start();
      }
      
      private function createRoom_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function createRoom_MOUSE_OUT(e:MouseEvent) : void
      {
      }
      
      private function createRoom_CLICK(e:MouseEvent) : void
      {
         var dummyGame:Game = null;
         if(m_subMenu.online_makeroom.createRoom_txt.text != "")
         {
            SaveData.saveGame();
            MultiplayerManager.Protocol = this.m_protocolDropDown.selectedItem.value;
            MultiplayerManager.INPUT_BUFFER = Boolean(this.m_bufferDropdown.selectedItem) ? int(this.m_bufferDropdown.selectedItem.value) : 3;
            m_subMenu.onlinebg.visible = false;
            m_subMenu.online_makeroom.visible = false;
            m_container.visible = false;
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            dummyGame = new Game();
            dummyGame.loadSavedVSOptions();
            dummyGame.LevelData.inputBuffer = MultiplayerManager.INPUT_BUFFER;
            MultiplayerManager.createRoom(m_subMenu.online_makeroom.createRoom_txt.text,m_subMenu.online_makeroom.roomPass_txt.text,this.m_roomCapacityDropdown.selectedItem.value,{
               "version":Version.getVersion(),
               "protocol":MultiplayerManager.Protocol,
               "matchSettings":dummyGame.exportSettings()
            });
            m_subMenu.online_makeroom.roomPass_txt.text = "";
            dummyGame = null;
            MenuController.pleaseWaitMenu.show();
         }
      }
      
      private function createRoomPopup_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Click to create a new room.";
      }
      
      private function createRoomPopup_MOUSE_OUT(e:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function createRoomPopup_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.onlinebg.visible = true;
         m_subMenu.online_makeroom.visible = true;
      }
      
      private function createRoomClose_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.onlinebg.visible = false;
         m_subMenu.online_makeroom.visible = false;
      }
      
      private function back_CLICK_online(e:MouseEvent) : void
      {
         MultiplayerManager.disconnect();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.desc_txt.text = "";
         MenuController.mainMenu.show();
      }
      
      private function back_ROLL_OVER_online(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         MultiplayerManager.disconnect();
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         removeSelf();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}

