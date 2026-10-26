package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.menus.*;
   
   public class MenuController
   {
      
      private static var m_debugConsole:DebugConsole;
      
      private static var m_blockedMenu:BlockedMenu;
      
      private static var m_introMenu:IntroMenu;
      
      private static var m_intro2Menu:Intro2Menu;
      
      private static var m_intro3Menu:Intro3Menu;
      
      private static var m_titleMenu:TitleMenu;
      
      private static var m_disclaimerMenu:DisclaimerMenu;
      
      private static var m_devAuthMenu:Menu;
      
      private static var m_devWarningMenu:DevWarningMenu;
      
      private static var m_creditsMenu:CreditsMenu;
      
      private static var m_loadingMenu:LoadingMenu;
      
      private static var m_mainMenu:MainMenu;
      
      private static var m_dataMenu:DataMenu;
      
      private static var m_groupMenu:GroupMenu;
      
      private static var m_arenaMenu:ArenaModeMenu;
      
      private static var m_onlineMenu:OnlineMenu;
      
      private static var m_onlineGroupMenu:OnlineGroupMenu;
      
      private static var m_onlinePromptMenu:OnlinePromptMenu;
      
      private static var m_optionsMenu:OptionsMenu;
      
      private static var m_qualityMenu:QualityMenu;
      
      private static var m_soloMenu:SoloMenu;
      
      private static var m_soundMenu:SoundMenu;
      
      private static var m_stadiumMenu:StadiumMenu;
      
      private static var m_stageSelectMenu:StageSelectMenu;
      
      private static var m_vaultMenu:VaultMenu;
      
      private static var m_newsMenu:NewsMenu;
      
      private static var m_newsArticleMenu:NewsArticleMenu;
      
      private static var m_vsMenu:VSMenu;
      
      private static var m_classicMenu:ClassicModeMenu;
      
      private static var m_allstarMenu:AllStarModeMenu;
      
      private static var m_eventMenu:EventMenu;
      
      private static var m_eventMatchCharacterMenu:EventMatchCharacterMenu;
      
      private static var m_onlineCharacterMenu:OnlineCharacterMenu;
      
      private static var m_trainingMenu:TrainingMenu;
      
      private static var m_targetTestMenu:TargetTestMenu;
      
      private static var m_homeRunContestMenu:HomeRunContestMenu;
      
      private static var m_arenaCharacterSelectMenu:ArenaCharacterSelectMenu;
      
      private static var m_multimanCharacterSelectMenu:MultiManCharacterSelectMenu;
      
      private static var m_crystalSmashCharacterMenu:CrystalSmashCharacterMenu;
      
      private static var m_raceToTheFinishCharacterMenu:RaceToTheFinishCharacterMenu;
      
      private static var m_multimanMenu:MultiManMenu;
      
      private static var m_rulesMenu:RulesMenu;
      
      private static var m_specialModeMenu:SpecialModeMenu;
      
      private static var m_controlsMenu:ControlsMenu;
      
      private static var m_gamepadMenu:GamepadMenu;
      
      private static var m_itemSwitchMenu:ItemSwitchMenu;
      
      private static var m_stageSwitchMenu:StageSwitchMenu;
      
      private static var m_matchResultsMenu:MatchResultsMenu;
      
      private static var m_preUnlockMenu:PreUnlockMenu;
      
      private static var m_postUnlockMenu:PostUnlockMenu;
      
      private static var m_pleaseWaitMenu:PleaseWaitMenu;
      
      private static var m_muteMenu:MuteMenu;
      
      private static var m_currentCharacterSelectMenu:CharacterSelectMenu;
      
      private static var m_customMenus:Vector.<CustomAPIMenu> = new Vector.<CustomAPIMenu>();
      
      public function MenuController()
      {
         super();
      }
      
      public static function init() : void
      {
         if(Main.DEBUG)
         {
            m_debugConsole = new DebugConsole();
         }
         m_currentCharacterSelectMenu = null;
         trace("MenuController class initialized");
      }
      
      public static function disposeAllMenus(disposePreserevedMenus:Boolean = false) : void
      {
         removeAllMenus();
         m_blockedMenu = null;
         m_introMenu = null;
         m_intro2Menu = null;
         m_intro3Menu = null;
         m_titleMenu = null;
         m_disclaimerMenu = null;
         m_devAuthMenu = null;
         m_devWarningMenu = null;
         m_creditsMenu = null;
         m_loadingMenu = null;
         m_mainMenu = null;
         m_dataMenu = null;
         m_groupMenu = null;
         m_onlineMenu = null;
         m_onlineGroupMenu = null;
         m_onlinePromptMenu = null;
         m_optionsMenu = null;
         m_qualityMenu = null;
         m_soloMenu = null;
         m_soundMenu = null;
         m_stadiumMenu = null;
         m_stageSelectMenu = null;
         m_vaultMenu = null;
         m_newsMenu = null;
         m_newsArticleMenu = null;
         if(disposePreserevedMenus)
         {
            m_eventMenu = null;
         }
         m_multimanMenu = null;
         m_rulesMenu = null;
         m_specialModeMenu = null;
         m_controlsMenu = null;
         m_gamepadMenu = null;
         m_itemSwitchMenu = null;
         m_stageSwitchMenu = null;
         m_matchResultsMenu = null;
         m_preUnlockMenu = null;
         m_postUnlockMenu = null;
         m_pleaseWaitMenu = null;
         m_muteMenu = null;
         if(disposePreserevedMenus)
         {
            m_vsMenu = null;
            m_classicMenu = null;
            m_allstarMenu = null;
            m_eventMatchCharacterMenu = null;
            m_onlineMenu = null;
            m_onlineGroupMenu = null;
            m_trainingMenu = null;
            m_targetTestMenu = null;
            m_homeRunContestMenu = null;
            m_arenaCharacterSelectMenu = null;
            m_arenaMenu = null;
            m_multimanCharacterSelectMenu = null;
            m_crystalSmashCharacterMenu = null;
            m_raceToTheFinishCharacterMenu = null;
            m_currentCharacterSelectMenu = null;
         }
      }
      
      public static function removeAllMenus() : void
      {
         if(Boolean(m_blockedMenu))
         {
            m_blockedMenu.removeSelf();
         }
         if(Boolean(m_introMenu))
         {
            m_introMenu.removeSelf();
         }
         if(Boolean(m_intro2Menu))
         {
            m_intro2Menu.removeSelf();
         }
         if(Boolean(m_intro3Menu))
         {
            m_intro3Menu.removeSelf();
         }
         if(Boolean(m_titleMenu))
         {
            m_titleMenu.removeSelf();
         }
         if(Boolean(m_disclaimerMenu))
         {
            m_disclaimerMenu.removeSelf();
         }
         if(Boolean(m_devAuthMenu))
         {
            m_devAuthMenu.removeSelf();
         }
         if(Boolean(m_devWarningMenu))
         {
            m_devWarningMenu.removeSelf();
         }
         if(Boolean(m_creditsMenu))
         {
            m_creditsMenu.removeSelf();
         }
         if(Boolean(m_loadingMenu))
         {
            m_loadingMenu.removeSelf();
         }
         if(Boolean(m_mainMenu))
         {
            m_mainMenu.removeSelf();
         }
         if(Boolean(m_dataMenu))
         {
            m_dataMenu.removeSelf();
         }
         if(Boolean(m_groupMenu))
         {
            m_groupMenu.removeSelf();
         }
         if(Boolean(m_arenaMenu))
         {
            m_arenaMenu.removeSelf();
         }
         if(Boolean(m_onlineMenu))
         {
            m_onlineMenu.removeSelf();
         }
         if(Boolean(m_onlineGroupMenu))
         {
            m_onlineGroupMenu.removeSelf();
         }
         if(Boolean(m_onlinePromptMenu))
         {
            m_onlinePromptMenu.removeSelf();
         }
         if(Boolean(m_optionsMenu))
         {
            m_optionsMenu.removeSelf();
         }
         if(Boolean(m_qualityMenu))
         {
            m_qualityMenu.removeSelf();
         }
         if(Boolean(m_soloMenu))
         {
            m_soloMenu.removeSelf();
         }
         if(Boolean(m_soundMenu))
         {
            m_soundMenu.removeSelf();
         }
         if(Boolean(m_stadiumMenu))
         {
            m_stadiumMenu.removeSelf();
         }
         if(Boolean(m_stageSelectMenu))
         {
            m_stageSelectMenu.removeSelf();
         }
         if(Boolean(m_vaultMenu))
         {
            m_vaultMenu.removeSelf();
         }
         if(Boolean(m_newsMenu))
         {
            m_newsMenu.removeSelf();
         }
         if(Boolean(m_newsArticleMenu))
         {
            m_newsArticleMenu.removeSelf();
         }
         if(Boolean(m_rulesMenu))
         {
            m_rulesMenu.removeSelf();
         }
         if(Boolean(m_specialModeMenu))
         {
            m_specialModeMenu.removeSelf();
         }
         if(Boolean(m_controlsMenu))
         {
            m_controlsMenu.removeSelf();
         }
         if(Boolean(m_gamepadMenu))
         {
            m_gamepadMenu.removeSelf();
         }
         if(Boolean(m_itemSwitchMenu))
         {
            m_itemSwitchMenu.removeSelf();
         }
         if(Boolean(m_stageSwitchMenu))
         {
            m_stageSwitchMenu.removeSelf();
         }
         if(Boolean(m_preUnlockMenu))
         {
            m_preUnlockMenu.removeSelf();
         }
         if(Boolean(m_postUnlockMenu))
         {
            m_postUnlockMenu.removeSelf();
         }
         if(Boolean(m_pleaseWaitMenu))
         {
            m_pleaseWaitMenu.removeSelf();
         }
         if(Boolean(m_muteMenu))
         {
            m_muteMenu.removeSelf();
         }
         if(Boolean(m_matchResultsMenu))
         {
            m_matchResultsMenu.removeSelf();
         }
         if(Boolean(m_vsMenu))
         {
            m_vsMenu.removeSelf();
         }
         if(Boolean(m_classicMenu))
         {
            m_classicMenu.removeSelf();
         }
         if(Boolean(m_allstarMenu))
         {
            m_allstarMenu.removeSelf();
         }
         if(Boolean(m_eventMatchCharacterMenu))
         {
            m_eventMatchCharacterMenu.removeSelf();
         }
         if(Boolean(m_trainingMenu))
         {
            m_trainingMenu.removeSelf();
         }
         if(Boolean(m_targetTestMenu))
         {
            m_targetTestMenu.removeSelf();
         }
         if(Boolean(m_homeRunContestMenu))
         {
            m_homeRunContestMenu.removeSelf();
         }
         if(Boolean(m_arenaCharacterSelectMenu))
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(Boolean(m_multimanCharacterSelectMenu))
         {
            m_multimanCharacterSelectMenu.removeSelf();
         }
         if(Boolean(m_crystalSmashCharacterMenu))
         {
            m_crystalSmashCharacterMenu.removeSelf();
         }
         if(Boolean(m_raceToTheFinishCharacterMenu))
         {
            m_raceToTheFinishCharacterMenu.removeSelf();
         }
         if(Boolean(m_arenaCharacterSelectMenu))
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(Boolean(m_arenaCharacterSelectMenu))
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(Boolean(m_currentCharacterSelectMenu))
         {
            m_currentCharacterSelectMenu.removeSelf();
         }
         while(m_customMenus.length > 0)
         {
            m_customMenus[0].removeSelf();
            m_customMenus.splice(0,1);
         }
      }
      
      public static function get debugConsole() : DebugConsole
      {
         return m_debugConsole;
      }
      
      public static function get blockedMenu() : Menu
      {
         if(!m_blockedMenu)
         {
            m_blockedMenu = new BlockedMenu();
         }
         return m_blockedMenu;
      }
      
      public static function get introMenu() : IntroMenu
      {
         return m_introMenu;
      }
      
      public static function set introMenu(menu:IntroMenu) : void
      {
         m_introMenu = menu;
      }
      
      public static function get intro2Menu() : Intro2Menu
      {
         return m_intro2Menu;
      }
      
      public static function set intro2Menu(menu:Intro2Menu) : void
      {
         m_intro2Menu = menu;
      }
      
      public static function get intro3Menu() : Intro3Menu
      {
         if(!m_intro3Menu)
         {
            m_intro3Menu = new Intro3Menu();
         }
         return m_intro3Menu;
      }
      
      public static function set intro3Menu(menu:Intro3Menu) : void
      {
         m_intro3Menu = menu;
      }
      
      public static function get titleMenu() : TitleMenu
      {
         if(!m_titleMenu)
         {
            m_titleMenu = new TitleMenu();
         }
         return m_titleMenu;
      }
      
      public static function get disclaimerMenu() : DisclaimerMenu
      {
         if(!m_disclaimerMenu)
         {
            m_disclaimerMenu = new DisclaimerMenu();
         }
         return m_disclaimerMenu;
      }
      
      public static function get devWarningMenu() : Menu
      {
         if(!m_devWarningMenu)
         {
            m_devWarningMenu = new DevWarningMenu();
         }
         return m_devWarningMenu;
      }
      
      public static function get creditsMenu() : CreditsMenu
      {
         if(!m_creditsMenu)
         {
            m_creditsMenu = new CreditsMenu();
         }
         return m_creditsMenu;
      }
      
      public static function get loadingMenu() : LoadingMenu
      {
         if(!m_loadingMenu)
         {
            m_loadingMenu = new LoadingMenu();
         }
         return m_loadingMenu;
      }
      
      public static function get mainMenu() : MainMenu
      {
         if(!m_mainMenu)
         {
            m_mainMenu = new MainMenu();
         }
         return m_mainMenu;
      }
      
      public static function get dataMenu() : DataMenu
      {
         if(!m_dataMenu)
         {
            m_dataMenu = new DataMenu();
         }
         return m_dataMenu;
      }
      
      public static function get groupMenu() : GroupMenu
      {
         if(!m_groupMenu)
         {
            m_groupMenu = new GroupMenu();
         }
         return m_groupMenu;
      }
      
      public static function get arenaMenu() : ArenaModeMenu
      {
         if(!m_arenaMenu)
         {
            m_arenaMenu = new ArenaModeMenu();
         }
         return m_arenaMenu;
      }
      
      public static function get onlineMenu() : OnlineMenu
      {
         if(!m_onlineMenu)
         {
            m_onlineMenu = new OnlineMenu();
         }
         return m_onlineMenu;
      }
      
      public static function get onlineGroupMenu() : OnlineGroupMenu
      {
         if(!m_onlineGroupMenu)
         {
            m_onlineGroupMenu = new OnlineGroupMenu();
         }
         return m_onlineGroupMenu;
      }
      
      public static function get onlinePromptMenu() : OnlinePromptMenu
      {
         if(!m_onlinePromptMenu)
         {
            m_onlinePromptMenu = new OnlinePromptMenu();
         }
         return m_onlinePromptMenu;
      }
      
      public static function get optionsMenu() : OptionsMenu
      {
         if(!m_optionsMenu)
         {
            m_optionsMenu = new OptionsMenu();
         }
         return m_optionsMenu;
      }
      
      public static function get qualityMenu() : QualityMenu
      {
         if(!m_qualityMenu)
         {
            m_qualityMenu = new QualityMenu();
         }
         return m_qualityMenu;
      }
      
      public static function get soloMenu() : SoloMenu
      {
         if(!m_soloMenu)
         {
            m_soloMenu = new SoloMenu();
         }
         return m_soloMenu;
      }
      
      public static function get soundMenu() : SoundMenu
      {
         if(!m_soundMenu)
         {
            m_soundMenu = new SoundMenu();
         }
         return m_soundMenu;
      }
      
      public static function get stadiumMenu() : StadiumMenu
      {
         if(!m_stadiumMenu)
         {
            m_stadiumMenu = new StadiumMenu();
         }
         return m_stadiumMenu;
      }
      
      public static function get stageSelectMenu() : StageSelectMenu
      {
         if(!m_stageSelectMenu)
         {
            m_stageSelectMenu = new StageSelectMenu();
         }
         return m_stageSelectMenu;
      }
      
      public static function get vaultMenu() : VaultMenu
      {
         if(!m_vaultMenu)
         {
            m_vaultMenu = new VaultMenu();
         }
         return m_vaultMenu;
      }
      
      public static function get newsMenu() : NewsMenu
      {
         if(!m_newsMenu)
         {
            m_newsMenu = new NewsMenu();
         }
         return m_newsMenu;
      }
      
      public static function get newsArticleMenu() : NewsArticleMenu
      {
         if(!m_newsArticleMenu)
         {
            m_newsArticleMenu = new NewsArticleMenu();
         }
         return m_newsArticleMenu;
      }
      
      public static function get vsMenu() : VSMenu
      {
         if(!m_vsMenu)
         {
            m_vsMenu = new VSMenu("menu_charselect_vs");
            m_currentCharacterSelectMenu = m_vsMenu;
         }
         return m_vsMenu;
      }
      
      public static function get classicMenu() : ClassicModeMenu
      {
         if(!m_classicMenu)
         {
            m_classicMenu = new ClassicModeMenu("menu_charselect_classic");
            m_currentCharacterSelectMenu = m_classicMenu;
         }
         return m_classicMenu;
      }
      
      public static function get allstarMenu() : AllStarModeMenu
      {
         if(!m_allstarMenu)
         {
            m_allstarMenu = new AllStarModeMenu("menu_charselect_allstar");
            m_currentCharacterSelectMenu = m_allstarMenu;
         }
         return m_allstarMenu;
      }
      
      public static function get eventMenu() : EventMenu
      {
         if(!m_eventMenu)
         {
            m_eventMenu = new EventMenu();
         }
         return m_eventMenu;
      }
      
      public static function get eventMatchCharacterMenu() : EventMatchCharacterMenu
      {
         if(!m_eventMatchCharacterMenu)
         {
            m_eventMatchCharacterMenu = new EventMatchCharacterMenu("menu_charselect_event");
            m_currentCharacterSelectMenu = m_eventMatchCharacterMenu;
         }
         return m_eventMatchCharacterMenu;
      }
      
      public static function get onlineCharacterMenu() : OnlineCharacterMenu
      {
         if(!m_onlineCharacterMenu)
         {
            m_onlineCharacterMenu = new OnlineCharacterMenu("menu_charselect_online");
            m_currentCharacterSelectMenu = m_onlineCharacterMenu;
         }
         return m_onlineCharacterMenu;
      }
      
      public static function get trainingMenu() : TrainingMenu
      {
         if(!m_trainingMenu)
         {
            m_trainingMenu = new TrainingMenu("menu_charselect_training");
            m_currentCharacterSelectMenu = m_trainingMenu;
         }
         return m_trainingMenu;
      }
      
      public static function get targetTestMenu() : TargetTestMenu
      {
         if(!m_targetTestMenu)
         {
            m_targetTestMenu = new TargetTestMenu("menu_charselect_targettest");
            m_currentCharacterSelectMenu = m_targetTestMenu;
         }
         return m_targetTestMenu;
      }
      
      public static function get homeRunContestMenu() : HomeRunContestMenu
      {
         if(!m_homeRunContestMenu)
         {
            m_homeRunContestMenu = new HomeRunContestMenu("menu_charselect_hrc");
            m_currentCharacterSelectMenu = m_homeRunContestMenu;
         }
         return m_homeRunContestMenu;
      }
      
      public static function get arenaCharacterSelectMenu() : ArenaCharacterSelectMenu
      {
         if(!m_arenaCharacterSelectMenu)
         {
            m_arenaCharacterSelectMenu = new ArenaCharacterSelectMenu("menu_charselect_arena");
            m_currentCharacterSelectMenu = m_arenaCharacterSelectMenu;
         }
         return m_arenaCharacterSelectMenu;
      }
      
      public static function get multimanCharacterSelectMenu() : MultiManCharacterSelectMenu
      {
         if(!m_multimanCharacterSelectMenu)
         {
            m_multimanCharacterSelectMenu = new MultiManCharacterSelectMenu("menu_charselect_multiman");
            m_currentCharacterSelectMenu = m_multimanCharacterSelectMenu;
         }
         return m_multimanCharacterSelectMenu;
      }
      
      public static function get multimanMenu() : MultiManMenu
      {
         if(!m_multimanMenu)
         {
            m_multimanMenu = new MultiManMenu();
         }
         return m_multimanMenu;
      }
      
      public static function get crystalSmashCharacterMenu() : CrystalSmashCharacterMenu
      {
         if(!m_crystalSmashCharacterMenu)
         {
            m_crystalSmashCharacterMenu = new CrystalSmashCharacterMenu("menu_charselect_crystal");
            m_currentCharacterSelectMenu = m_crystalSmashCharacterMenu;
         }
         return m_crystalSmashCharacterMenu;
      }
      
      public static function get raceToTheFinishCharacterMenu() : RaceToTheFinishCharacterMenu
      {
         if(!m_raceToTheFinishCharacterMenu)
         {
            m_raceToTheFinishCharacterMenu = new RaceToTheFinishCharacterMenu("menu_charselect_rttf");
            m_currentCharacterSelectMenu = m_raceToTheFinishCharacterMenu;
         }
         return m_raceToTheFinishCharacterMenu;
      }
      
      public static function get rulesMenu() : RulesMenu
      {
         if(!m_rulesMenu)
         {
            m_rulesMenu = new RulesMenu();
         }
         return m_rulesMenu;
      }
      
      public static function get specialModeMenu() : SpecialModeMenu
      {
         if(!m_specialModeMenu)
         {
            m_specialModeMenu = new SpecialModeMenu();
         }
         return m_specialModeMenu;
      }
      
      public static function get controlsMenu() : ControlsMenu
      {
         if(!m_controlsMenu)
         {
            m_controlsMenu = new ControlsMenu();
         }
         return m_controlsMenu;
      }
      
      public static function get gamepadMenu() : GamepadMenu
      {
         if(!m_gamepadMenu)
         {
            m_gamepadMenu = new GamepadMenu();
         }
         return m_gamepadMenu;
      }
      
      public static function get itemSwitchMenu() : ItemSwitchMenu
      {
         if(!m_itemSwitchMenu)
         {
            m_itemSwitchMenu = new ItemSwitchMenu();
         }
         return m_itemSwitchMenu;
      }
      
      public static function get stageSwitchMenu() : StageSwitchMenu
      {
         if(!m_stageSwitchMenu)
         {
            m_stageSwitchMenu = new StageSwitchMenu();
         }
         return m_stageSwitchMenu;
      }
      
      public static function get matchResultsMenu() : MatchResultsMenu
      {
         return m_matchResultsMenu;
      }
      
      public static function set matchResultsMenu(value:MatchResultsMenu) : void
      {
         m_matchResultsMenu = value;
      }
      
      public static function get preUnlockMenu() : PreUnlockMenu
      {
         if(!m_preUnlockMenu)
         {
            m_preUnlockMenu = new PreUnlockMenu();
         }
         return m_preUnlockMenu;
      }
      
      public static function get postUnlockMenu() : PostUnlockMenu
      {
         if(!m_postUnlockMenu)
         {
            m_postUnlockMenu = new PostUnlockMenu();
         }
         return m_postUnlockMenu;
      }
      
      public static function get pleaseWaitMenu() : PleaseWaitMenu
      {
         if(!m_pleaseWaitMenu)
         {
            m_pleaseWaitMenu = new PleaseWaitMenu();
         }
         return m_pleaseWaitMenu;
      }
      
      public static function get muteMenu() : MuteMenu
      {
         if(!m_muteMenu)
         {
            m_muteMenu = new MuteMenu();
         }
         return m_muteMenu;
      }
      
      public static function get customMenus() : Vector.<CustomAPIMenu>
      {
         return m_customMenus;
      }
      
      public static function get CurrentCharacterSelectMenu() : CharacterSelectMenu
      {
         return m_currentCharacterSelectMenu;
      }
      
      public static function set CurrentCharacterSelectMenu(value:CharacterSelectMenu) : void
      {
         m_currentCharacterSelectMenu = value;
      }
      
      public static function showInitialMenu() : void
      {
         MenuController.disclaimerMenu.show();
      }
      
      public static function hasControlsMenu() : Boolean
      {
         return m_controlsMenu !== null;
      }
      
      public static function hasItemSwitchMenu() : Boolean
      {
         return m_itemSwitchMenu !== null;
      }
      
      public static function hasStageSwitchMenu() : Boolean
      {
         return m_stageSwitchMenu !== null;
      }
   }
}

