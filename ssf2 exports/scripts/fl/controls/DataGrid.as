package fl.controls
{
   import fl.controls.dataGridClasses.DataGridColumn;
   import fl.controls.dataGridClasses.HeaderRenderer;
   import fl.controls.listClasses.ICellRenderer;
   import fl.controls.listClasses.ListData;
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.data.DataProvider;
   import fl.events.DataChangeEvent;
   import fl.events.DataGridEvent;
   import fl.events.DataGridEventReason;
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   [InspectableList("verticalScrollPolicy")]
   [Style(name="headerRenderer",type="Class")]
   [Style(name="headerTextPadding",type="Number",format="Length")]
   [Style(name="headerDisabledTextFormat",type="flash.text.TextFormat")]
   [Style(name="headerTextFormat",type="flash.text.TextFormat")]
   [Style(name="headerSortArrowAscSkin",type="Class")]
   [Style(name="headerSortArrowDescSkin",type="Class")]
   [Style(name="headerDisabledSkin",type="Class")]
   [Style(name="headerDownSkin",type="Class")]
   [Style(name="headerOverSkin",type="Class")]
   [Style(name="headerUpSkin",type="Class")]
   [Style(name="columnDividerSkin",type="Class")]
   [Style(name="columnStretchCursorSkin",type="Class")]
   [Event(name="itemFocusOut",type="fl.events.DataGridEvent")]
   [Event(name="itemFocusIn",type="fl.events.DataGridEvent")]
   [Event(name="itemEditEnd",type="fl.events.DataGridEvent")]
   [Event(name="itemEditBegin",type="fl.events.DataGridEvent")]
   [Event(name="itemEditBeginning",type="fl.events.DataGridEvent")]
   [Event(name="columnStretch",type="fl.events.DataGridEvent")]
   [Event(name="headerRelease",type="fl.events.DataGridEvent")]
   [Embed(source="/_assets/assets.swf", symbol="symbol502")]
   public class DataGrid extends SelectableList implements IFocusManagerComponent
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private static var defaultStyles:Object = {
         "headerUpSkin":"HeaderRenderer_upSkin",
         "headerDownSkin":"HeaderRenderer_downSkin",
         "headerOverSkin":"HeaderRenderer_overSkin",
         "headerDisabledSkin":"HeaderRenderer_disabledSkin",
         "headerSortArrowDescSkin":"HeaderSortArrow_descIcon",
         "headerSortArrowAscSkin":"HeaderSortArrow_ascIcon",
         "columnStretchCursorSkin":"ColumnStretch_cursor",
         "columnDividerSkin":null,
         "headerTextFormat":null,
         "headerDisabledTextFormat":null,
         "headerTextPadding":5,
         "headerRenderer":HeaderRenderer,
         "focusRectSkin":null,
         "focusRectPadding":null,
         "skin":"DataGrid_skin"
      };
      
      protected static const HEADER_STYLES:Object = {
         "disabledSkin":"headerDisabledSkin",
         "downSkin":"headerDownSkin",
         "overSkin":"headerOverSkin",
         "upSkin":"headerUpSkin",
         "textFormat":"headerTextFormat",
         "disabledTextFormat":"headerDisabledTextFormat",
         "textPadding":"headerTextPadding"
      };
      
      protected var _rowHeight:Number = 20;
      
      protected var _headerHeight:Number = 25;
      
      protected var _showHeaders:Boolean = true;
      
      protected var _columns:Array;
      
      protected var _minColumnWidth:Number;
      
      protected var header:Sprite;
      
      protected var headerMask:Sprite;
      
      protected var headerSortArrow:Sprite;
      
      protected var _cellRenderer:Object;
      
      protected var _headerRenderer:Object;
      
      protected var _labelFunction:Function;
      
      protected var visibleColumns:Array;
      
      protected var displayableColumns:Array;
      
      protected var columnsInvalid:Boolean = true;
      
      protected var minColumnWidthInvalid:Boolean = false;
      
      protected var activeCellRenderersMap:Dictionary;
      
      protected var availableCellRenderersMap:Dictionary;
      
      protected var dragHandlesMap:Dictionary;
      
      protected var columnStretchIndex:Number = -1;
      
      protected var columnStretchStartX:Number;
      
      protected var columnStretchStartWidth:Number;
      
      protected var columnStretchCursor:Sprite;
      
      protected var _sortIndex:int = -1;
      
      protected var lastSortIndex:int = -1;
      
      protected var _sortDescending:Boolean = false;
      
      protected var _editedItemPosition:Object;
      
      protected var editedItemPositionChanged:Boolean = false;
      
      protected var proposedEditedItemPosition:*;
      
      protected var actualRowIndex:int;
      
      protected var actualColIndex:int;
      
      protected var isPressed:Boolean = false;
      
      protected var losingFocus:Boolean = false;
      
      protected var maxHeaderHeight:Number = 25;
      
      protected var currentHoveredRow:int = -1;
      
      [Inspectable(defaultValue="false")]
      public var editable:Boolean = false;
      
      [Inspectable(defaultValue="true")]
      public var resizableColumns:Boolean = true;
      
      [Inspectable(defaultValue="true")]
      public var sortableColumns:Boolean = true;
      
      public var itemEditorInstance:Object;
      
      public function DataGrid()
      {
         super();
         if(this._columns == null)
         {
            this._columns = [];
         }
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         this.activeCellRenderersMap = new Dictionary(true);
         this.availableCellRenderersMap = new Dictionary(true);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,this.itemEditorItemEditBeginningHandler,false,-50);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,this.itemEditorItemEditBeginHandler,false,-50);
         addEventListener(DataGridEvent.ITEM_EDIT_END,this.itemEditorItemEditEndHandler,false,-50);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,SelectableList.getStyleDefinition(),ScrollBar.getStyleDefinition());
      }
      
      override public function set dataProvider(param1:DataProvider) : void
      {
         super.dataProvider = param1;
         if(this._columns == null)
         {
            this._columns = [];
         }
         if(this._columns.length == 0)
         {
            this.createColumnsFromDataProvider();
         }
         this.removeCellRenderers();
      }
      
      [Inspectable(defaultValue="true",verbose="1")]
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.header.mouseChildren = _enabled;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
         this.columnsInvalid = true;
      }
      
      [Inspectable(defaultValue="off",enumeration="on,off,auto")]
      override public function get horizontalScrollPolicy() : String
      {
         return _horizontalScrollPolicy;
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
         super.horizontalScrollPolicy = param1;
         this.columnsInvalid = true;
      }
      
      public function get columns() : Array
      {
         return this._columns.slice(0);
      }
      
      public function set columns(param1:Array) : void
      {
         this.removeCellRenderers();
         this._columns = [];
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            this.addColumn(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get minColumnWidth() : Number
      {
         return this._minColumnWidth;
      }
      
      public function set minColumnWidth(param1:Number) : void
      {
         this._minColumnWidth = param1;
         this.columnsInvalid = true;
         this.minColumnWidthInvalid = true;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         if(this._labelFunction == param1)
         {
            return;
         }
         this._labelFunction = param1;
         invalidate(InvalidationType.DATA);
      }
      
      override public function get rowCount() : uint
      {
         return Math.ceil(this.calculateAvailableHeight() / this.rowHeight);
      }
      
      public function set rowCount(param1:uint) : void
      {
         var _loc2_:Number = Number(getStyleValue("contentPadding"));
         var _loc3_:Number = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && hScrollBar ? 15 : 0;
         height = this.rowHeight * param1 + 2 * _loc2_ + _loc3_ + (this.showHeaders ? this.headerHeight : 0);
      }
      
      [Inspectable(defaultValue="20")]
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(param1:Number) : void
      {
         this._rowHeight = Math.max(0,param1);
         invalidate(InvalidationType.SIZE);
      }
      
      [Inspectable(defaultValue="25")]
      public function get headerHeight() : Number
      {
         return this._headerHeight;
      }
      
      public function set headerHeight(param1:Number) : void
      {
         this.maxHeaderHeight = param1;
         this._headerHeight = Math.max(0,param1);
         invalidate(InvalidationType.SIZE);
      }
      
      [Inspectable(defaultValue="true")]
      public function get showHeaders() : Boolean
      {
         return this._showHeaders;
      }
      
      public function set showHeaders(param1:Boolean) : void
      {
         this._showHeaders = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get sortIndex() : int
      {
         return this._sortIndex;
      }
      
      public function get sortDescending() : Boolean
      {
         return this._sortDescending;
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      public function get editedItemRenderer() : ICellRenderer
      {
         if(!this.itemEditorInstance)
         {
            return null;
         }
         return this.getCellRendererAt(this.actualRowIndex,this.actualColIndex);
      }
      
      public function get editedItemPosition() : Object
      {
         if(Boolean(this._editedItemPosition))
         {
            return {
               "rowIndex":this._editedItemPosition.rowIndex,
               "columnIndex":this._editedItemPosition.columnIndex
            };
         }
         return this._editedItemPosition;
      }
      
      public function set editedItemPosition(param1:Object) : void
      {
         var _loc2_:Object = {
            "rowIndex":param1.rowIndex,
            "columnIndex":param1.columnIndex
         };
         this.setEditedItemPosition(_loc2_);
      }
      
      protected function calculateAvailableHeight() : Number
      {
         var _loc1_:Number = Number(getStyleValue("contentPadding"));
         var _loc2_:Number = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && _maxHorizontalScrollPosition > 0 ? 15 : 0;
         return height - _loc1_ * 2 - _loc2_ - (this.showHeaders ? this.headerHeight : 0);
      }
      
      public function addColumn(param1:*) : DataGridColumn
      {
         return this.addColumnAt(param1,this._columns.length);
      }
      
      public function addColumnAt(param1:*, param2:uint) : DataGridColumn
      {
         var _loc3_:DataGridColumn = null;
         var _loc5_:uint = 0;
         if(param2 < this._columns.length)
         {
            this._columns.splice(param2,0,"");
            _loc5_ = param2 + 1;
            while(_loc5_ < this._columns.length)
            {
               _loc3_ = this._columns[_loc5_] as DataGridColumn;
               _loc3_.colNum = _loc5_;
               _loc5_++;
            }
         }
         var _loc4_:* = param1;
         if(!(_loc4_ is DataGridColumn))
         {
            if(_loc4_ is String)
            {
               _loc4_ = new DataGridColumn(_loc4_);
            }
            else
            {
               _loc4_ = new DataGridColumn();
            }
         }
         _loc3_ = _loc4_ as DataGridColumn;
         _loc3_.owner = this;
         _loc3_.colNum = param2;
         this._columns[param2] = _loc3_;
         invalidate(InvalidationType.SIZE);
         this.columnsInvalid = true;
         return _loc3_;
      }
      
      public function removeColumnAt(param1:uint) : DataGridColumn
      {
         var _loc3_:uint = 0;
         var _loc2_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(_loc2_ != null)
         {
            this.removeCellRenderersByColumn(_loc2_);
            this._columns.splice(param1,1);
            _loc3_ = param1;
            while(_loc3_ < this._columns.length)
            {
               _loc2_ = this._columns[_loc3_] as DataGridColumn;
               if(Boolean(_loc2_))
               {
                  _loc2_.colNum = _loc3_;
               }
               _loc3_++;
            }
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
         return _loc2_;
      }
      
      public function removeAllColumns() : void
      {
         if(this._columns.length > 0)
         {
            this.removeCellRenderers();
            this._columns = [];
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
      }
      
      public function getColumnAt(param1:uint) : DataGridColumn
      {
         return this._columns[param1] as DataGridColumn;
      }
      
      public function getColumnIndex(param1:String) : int
      {
         var _loc3_:DataGridColumn = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._columns.length)
         {
            _loc3_ = this._columns[_loc2_] as DataGridColumn;
            if(_loc3_.dataField == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getColumnCount() : uint
      {
         return this._columns.length;
      }
      
      public function spaceColumnsEqually() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:DataGridColumn = null;
         drawNow();
         if(this.displayableColumns.length > 0)
         {
            _loc1_ = availableWidth / this.displayableColumns.length;
            _loc2_ = 0;
            while(_loc2_ < this.displayableColumns.length)
            {
               _loc3_ = this.displayableColumns[_loc2_] as DataGridColumn;
               _loc3_.width = _loc1_;
               _loc2_++;
            }
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
      }
      
      public function editField(param1:uint, param2:String, param3:Object) : void
      {
         var _loc4_:Object = getItemAt(param1);
         _loc4_[param2] = param3;
         replaceItemAt(_loc4_,param1);
      }
      
      override public function itemToCellRenderer(param1:Object) : ICellRenderer
      {
         return null;
      }
      
      override protected function configUI() : void
      {
         useFixedHorizontalScrolling = false;
         super.configUI();
         this.headerMask = new Sprite();
         var _loc1_:Graphics = this.headerMask.graphics;
         _loc1_.beginFill(0,0.3);
         _loc1_.drawRect(0,0,100,100);
         _loc1_.endFill();
         this.headerMask.visible = false;
         addChild(this.headerMask);
         this.header = new Sprite();
         addChild(this.header);
         this.header.mask = this.headerMask;
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = contentHeight != this.rowHeight * length;
         contentHeight = this.rowHeight * length;
         if(isInvalid(InvalidationType.STYLES))
         {
            setStyles();
            drawBackground();
            if(contentPadding != getStyleValue("contentPadding"))
            {
               invalidate(InvalidationType.SIZE,false);
            }
            if(this._cellRenderer != getStyleValue("cellRenderer") || this._headerRenderer != getStyleValue("headerRenderer"))
            {
               _invalidateList();
               this._cellRenderer = getStyleValue("cellRenderer");
               this._headerRenderer = getStyleValue("headerRenderer");
            }
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            this.columnsInvalid = true;
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STATE) || _loc1_)
         {
            this.drawLayout();
            drawDisabledOverlay();
         }
         if(isInvalid(InvalidationType.RENDERER_STYLES))
         {
            this.updateRendererStyles();
         }
         if(isInvalid(InvalidationType.STYLES,InvalidationType.SIZE,InvalidationType.DATA,InvalidationType.SCROLL,InvalidationType.SELECTED))
         {
            this.drawList();
         }
         updateChildren();
         validate();
      }
      
      override protected function drawLayout() : void
      {
         vOffset = this.showHeaders ? this.headerHeight : 0;
         super.drawLayout();
         contentScrollRect = listHolder.scrollRect;
         if(this.showHeaders)
         {
            this.headerHeight = this.maxHeaderHeight;
            if(Math.floor(availableHeight - this.headerHeight) <= 0)
            {
               this._headerHeight = availableHeight;
            }
            list.y = this.headerHeight;
            contentScrollRect = listHolder.scrollRect;
            contentScrollRect.y = contentPadding + this.headerHeight;
            contentScrollRect.height = availableHeight - this.headerHeight;
            listHolder.y = contentPadding + this.headerHeight;
            this.headerMask.x = contentPadding;
            this.headerMask.y = contentPadding;
            this.headerMask.width = availableWidth;
            this.headerMask.height = this.headerHeight;
         }
         else
         {
            contentScrollRect.y = contentPadding;
            listHolder.y = 0;
         }
         listHolder.scrollRect = contentScrollRect;
      }
      
      override protected function drawList() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:ICellRenderer = null;
         var _loc8_:Array = null;
         var _loc9_:DataGridColumn = null;
         var _loc13_:Sprite = null;
         var _loc14_:UIComponent = null;
         var _loc18_:Number = NaN;
         var _loc19_:DataGridColumn = null;
         var _loc20_:Object = null;
         var _loc21_:Array = null;
         var _loc22_:Dictionary = null;
         var _loc23_:Object = null;
         var _loc24_:HeaderRenderer = null;
         var _loc25_:Sprite = null;
         var _loc26_:Graphics = null;
         var _loc27_:Boolean = false;
         var _loc28_:String = null;
         if(this.showHeaders)
         {
            this.header.visible = true;
            this.header.x = contentPadding - _horizontalScrollPosition;
            this.header.y = contentPadding;
            listHolder.y = contentPadding + this.headerHeight;
            _loc18_ = Math.floor(availableHeight - this.headerHeight);
            _verticalScrollBar.setScrollProperties(_loc18_,0,contentHeight - _loc18_,_verticalScrollBar.pageScrollSize);
         }
         else
         {
            this.header.visible = false;
            listHolder.y = contentPadding;
         }
         listHolder.x = contentPadding;
         contentScrollRect = listHolder.scrollRect;
         contentScrollRect.x = _horizontalScrollPosition;
         contentScrollRect.y = vOffset + Math.floor(_verticalScrollPosition) % this.rowHeight;
         listHolder.scrollRect = contentScrollRect;
         listHolder.cacheAsBitmap = useBitmapScrolling;
         var _loc1_:uint = Math.min(Math.max(length - 1,0),Math.floor(_verticalScrollPosition / this.rowHeight));
         var _loc2_:uint = Math.min(Math.max(length - 1,0),_loc1_ + this.rowCount + 1);
         var _loc10_:Boolean = list.hitTestPoint(stage.mouseX,stage.mouseY);
         this.calculateColumnSizes();
         var _loc11_:Dictionary = renderedItems = new Dictionary(true);
         if(length > 0)
         {
            _loc5_ = _loc1_;
            while(_loc5_ <= _loc2_)
            {
               _loc11_[_dataProvider.getItemAt(_loc5_)] = true;
               _loc5_++;
            }
         }
         _loc3_ = 0;
         var _loc12_:DataGridColumn = this.visibleColumns[0] as DataGridColumn;
         _loc5_ = 0;
         while(_loc5_ < this.displayableColumns.length)
         {
            _loc19_ = this.displayableColumns[_loc5_] as DataGridColumn;
            if(_loc19_ == _loc12_)
            {
               break;
            }
            _loc3_ += _loc19_.width;
            _loc5_++;
         }
         while(this.header.numChildren > 0)
         {
            this.header.removeChildAt(0);
         }
         this.dragHandlesMap = new Dictionary(true);
         var _loc15_:Array = [];
         var _loc16_:uint = this.visibleColumns.length;
         var _loc17_:uint = 0;
         while(_loc17_ < _loc16_)
         {
            _loc9_ = this.visibleColumns[_loc17_] as DataGridColumn;
            _loc15_.push(_loc9_.colNum);
            if(this.showHeaders)
            {
               _loc23_ = _loc9_.headerRenderer != null ? _loc9_.headerRenderer : this._headerRenderer;
               _loc24_ = getDisplayObjectInstance(_loc23_) as HeaderRenderer;
               if(_loc24_ != null)
               {
                  _loc24_.addEventListener(MouseEvent.CLICK,this.handleHeaderRendererClick,false,0,true);
                  _loc24_.x = _loc3_;
                  _loc24_.y = 0;
                  _loc24_.setSize(_loc9_.width,this.headerHeight);
                  _loc24_.column = _loc9_.colNum;
                  _loc24_.label = _loc9_.headerText;
                  this.header.addChildAt(_loc24_,_loc17_);
                  copyStylesToChild(_loc24_,HEADER_STYLES);
                  if(this.sortIndex == -1 && this.lastSortIndex == -1 || _loc9_.colNum != this.sortIndex)
                  {
                     _loc24_.setStyle("icon",null);
                  }
                  else
                  {
                     _loc24_.setStyle("icon",this.sortDescending ? getStyleValue("headerSortArrowAscSkin") : getStyleValue("headerSortArrowDescSkin"));
                  }
                  if(_loc17_ < _loc16_ - 1 && this.resizableColumns && _loc9_.resizable)
                  {
                     _loc25_ = new Sprite();
                     _loc26_ = _loc25_.graphics;
                     _loc26_.beginFill(0,0);
                     _loc26_.drawRect(0,0,3,this.headerHeight);
                     _loc26_.endFill();
                     _loc25_.x = _loc3_ + _loc9_.width - 2;
                     _loc25_.y = 0;
                     _loc25_.alpha = 0;
                     _loc25_.addEventListener(MouseEvent.MOUSE_OVER,this.handleHeaderResizeOver,false,0,true);
                     _loc25_.addEventListener(MouseEvent.MOUSE_OUT,this.handleHeaderResizeOut,false,0,true);
                     _loc25_.addEventListener(MouseEvent.MOUSE_DOWN,this.handleHeaderResizeDown,false,0,true);
                     this.header.addChild(_loc25_);
                     this.dragHandlesMap[_loc25_] = _loc9_.colNum;
                  }
                  if(_loc17_ == _loc16_ - 1 && _horizontalScrollPosition == 0 && availableWidth > _loc3_ + _loc9_.width)
                  {
                     _loc4_ = Math.floor(availableWidth - _loc3_);
                     _loc24_.setSize(_loc4_,this.headerHeight);
                  }
                  else
                  {
                     _loc4_ = _loc9_.width;
                  }
                  _loc24_.drawNow();
               }
            }
            _loc20_ = _loc9_.cellRenderer != null ? _loc9_.cellRenderer : this._cellRenderer;
            _loc21_ = this.availableCellRenderersMap[_loc9_];
            _loc8_ = this.activeCellRenderersMap[_loc9_];
            if(_loc8_ == null)
            {
               this.activeCellRenderersMap[_loc9_] = _loc8_ = [];
            }
            if(_loc21_ == null)
            {
               this.availableCellRenderersMap[_loc9_] = _loc21_ = [];
            }
            _loc22_ = new Dictionary(true);
            while(_loc8_.length > 0)
            {
               _loc7_ = _loc8_.pop();
               _loc6_ = _loc7_.data;
               if(_loc11_[_loc6_] == null || invalidItems[_loc6_] == true)
               {
                  _loc21_.push(_loc7_);
               }
               else
               {
                  _loc22_[_loc6_] = _loc7_;
                  invalidItems[_loc6_] = true;
               }
               list.removeChild(_loc7_ as DisplayObject);
            }
            if(length > 0)
            {
               _loc5_ = _loc1_;
               while(_loc5_ <= _loc2_)
               {
                  _loc27_ = false;
                  _loc6_ = _dataProvider.getItemAt(_loc5_);
                  if(_loc22_[_loc6_] != null)
                  {
                     _loc27_ = true;
                     _loc7_ = _loc22_[_loc6_];
                     delete _loc22_[_loc6_];
                  }
                  else if(_loc21_.length > 0)
                  {
                     _loc7_ = _loc21_.pop() as ICellRenderer;
                  }
                  else
                  {
                     _loc7_ = getDisplayObjectInstance(_loc20_) as ICellRenderer;
                     _loc13_ = _loc7_ as Sprite;
                     if(_loc13_ != null)
                     {
                        _loc13_.addEventListener(MouseEvent.CLICK,this.handleCellRendererClick,false,0,true);
                        _loc13_.addEventListener(MouseEvent.ROLL_OVER,this.handleCellRendererMouseEvent,false,0,true);
                        _loc13_.addEventListener(MouseEvent.ROLL_OUT,this.handleCellRendererMouseEvent,false,0,true);
                        _loc13_.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
                        _loc13_.doubleClickEnabled = true;
                        _loc13_.addEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false,0,true);
                        if(_loc13_["setStyle"] != null)
                        {
                           for(_loc28_ in rendererStyles)
                           {
                              _loc13_["setStyle"](_loc28_,rendererStyles[_loc28_]);
                           }
                        }
                     }
                  }
                  list.addChild(_loc7_ as Sprite);
                  _loc8_.push(_loc7_);
                  _loc7_.x = _loc3_;
                  _loc7_.y = this.rowHeight * (_loc5_ - _loc1_);
                  _loc7_.setSize(_loc17_ == _loc16_ - 1 ? _loc4_ : _loc9_.width,this.rowHeight);
                  if(!_loc27_)
                  {
                     _loc7_.data = _loc6_;
                  }
                  _loc7_.listData = new ListData(this.columnItemToLabel(_loc9_.colNum,_loc6_),null,this,_loc5_,_loc5_,_loc9_.colNum);
                  if(_loc10_ && this.isHovered(_loc7_))
                  {
                     _loc7_.setMouseState("over");
                     this.currentHoveredRow = _loc5_;
                  }
                  else
                  {
                     _loc7_.setMouseState("up");
                  }
                  _loc7_.selected = _selectedIndices.indexOf(_loc5_) != -1;
                  if(_loc7_ is UIComponent)
                  {
                     _loc14_ = _loc7_ as UIComponent;
                     _loc14_.drawNow();
                  }
                  _loc5_++;
               }
            }
            _loc3_ += _loc9_.width;
            _loc17_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._columns.length)
         {
            if(_loc15_.indexOf(_loc5_) == -1)
            {
               this.removeCellRenderersByColumn(this._columns[_loc5_] as DataGridColumn);
            }
            _loc5_++;
         }
         if(this.editedItemPositionChanged)
         {
            this.editedItemPositionChanged = false;
            this.commitEditedItemPosition(this.proposedEditedItemPosition);
            this.proposedEditedItemPosition = undefined;
         }
         invalidItems = new Dictionary(true);
      }
      
      override protected function updateRendererStyles() : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in this.availableCellRenderersMap)
         {
            _loc1_ = _loc1_.concat(this.availableCellRenderersMap[_loc2_]);
         }
         for(_loc2_ in this.activeCellRenderersMap)
         {
            _loc1_ = _loc1_.concat(this.activeCellRenderersMap[_loc2_]);
         }
         _loc3_ = _loc1_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc1_[_loc4_]["setStyle"] != null)
            {
               for(_loc5_ in updatedRendererStyles)
               {
                  _loc1_[_loc4_].setStyle(_loc5_,updatedRendererStyles[_loc5_]);
               }
               _loc1_[_loc4_].drawNow();
            }
            _loc4_++;
         }
         updatedRendererStyles = {};
      }
      
      protected function removeCellRenderers() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._columns.length)
         {
            this.removeCellRenderersByColumn(this._columns[_loc1_] as DataGridColumn);
            _loc1_++;
         }
      }
      
      protected function removeCellRenderersByColumn(param1:DataGridColumn) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = this.activeCellRenderersMap[param1];
         if(_loc2_ != null)
         {
            while(_loc2_.length > 0)
            {
               list.removeChild(_loc2_.pop() as DisplayObject);
            }
         }
      }
      
      override protected function handleCellRendererMouseEvent(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:DataGridColumn = null;
         var _loc7_:ICellRenderer = null;
         var _loc2_:ICellRenderer = param1.target as ICellRenderer;
         if(Boolean(_loc2_))
         {
            _loc3_ = int(_loc2_.listData.row);
            if(param1.type == MouseEvent.ROLL_OVER)
            {
               _loc4_ = "over";
            }
            else if(param1.type == MouseEvent.ROLL_OUT)
            {
               _loc4_ = "up";
            }
            if(Boolean(_loc4_))
            {
               _loc5_ = 0;
               while(_loc5_ < this.visibleColumns.length)
               {
                  _loc6_ = this.visibleColumns[_loc5_] as DataGridColumn;
                  _loc7_ = this.getCellRendererAt(_loc3_,_loc6_.colNum);
                  if(Boolean(_loc7_))
                  {
                     _loc7_.setMouseState(_loc4_);
                  }
                  if(_loc3_ != this.currentHoveredRow)
                  {
                     _loc7_ = this.getCellRendererAt(this.currentHoveredRow,_loc6_.colNum);
                     if(Boolean(_loc7_))
                     {
                        _loc7_.setMouseState("up");
                     }
                  }
                  _loc5_++;
               }
            }
         }
         super.handleCellRendererMouseEvent(param1);
      }
      
      protected function isHovered(param1:ICellRenderer) : Boolean
      {
         var _loc2_:uint = Math.min(Math.max(length - 1,0),Math.floor(_verticalScrollPosition / this.rowHeight));
         var _loc3_:Number = (param1.listData.row - _loc2_) * this.rowHeight;
         var _loc4_:Point = list.globalToLocal(new Point(0,stage.mouseY));
         return _loc4_.y > _loc3_ && _loc4_.y < _loc3_ + this.rowHeight;
      }
      
      override protected function setHorizontalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         if(param1 == _horizontalScrollPosition)
         {
            return;
         }
         contentScrollRect = listHolder.scrollRect;
         contentScrollRect.x = param1;
         listHolder.scrollRect = contentScrollRect;
         list.x = 0;
         this.header.x = -param1;
         super.setHorizontalScrollPosition(param1,true);
         invalidate(InvalidationType.SCROLL);
         this.columnsInvalid = true;
      }
      
      override protected function setVerticalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
         invalidate(InvalidationType.SCROLL);
         super.setVerticalScrollPosition(param1,true);
      }
      
      public function columnItemToLabel(param1:uint, param2:Object) : String
      {
         var _loc3_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(_loc3_ != null)
         {
            return _loc3_.itemToLabel(param2);
         }
         return " ";
      }
      
      protected function calculateColumnSizes() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:DataGridColumn = null;
         var _loc6_:DataGridColumn = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc4_:Number = 0;
         if(this._columns.length == 0)
         {
            this.visibleColumns = [];
            this.displayableColumns = [];
            return;
         }
         if(this.columnsInvalid)
         {
            this.columnsInvalid = false;
            this.visibleColumns = [];
            if(this.minColumnWidthInvalid)
            {
               _loc2_ = int(this._columns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this._columns[_loc3_].minWidth = this.minColumnWidth;
                  _loc3_++;
               }
               this.minColumnWidthInvalid = false;
            }
            this.displayableColumns = null;
            _loc2_ = int(this._columns.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(Boolean(this.displayableColumns) && Boolean(this._columns[_loc3_].visible))
               {
                  this.displayableColumns.push(this._columns[_loc3_]);
               }
               else if(!this.displayableColumns && !this._columns[_loc3_].visible)
               {
                  this.displayableColumns = new Array(_loc3_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc3_)
                  {
                     this.displayableColumns[_loc8_] = this._columns[_loc8_];
                     _loc8_++;
                  }
               }
               _loc3_++;
            }
            if(!this.displayableColumns)
            {
               this.displayableColumns = this._columns;
            }
            if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               _loc2_ = int(this.displayableColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this.visibleColumns.push(this.displayableColumns[_loc3_]);
                  _loc3_++;
               }
            }
            else
            {
               _loc2_ = int(this.displayableColumns.length);
               _loc9_ = 0;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_ = this.displayableColumns[_loc3_] as DataGridColumn;
                  if(_loc9_ + _loc5_.width > _horizontalScrollPosition && _loc9_ < _horizontalScrollPosition + availableWidth)
                  {
                     this.visibleColumns.push(_loc5_);
                  }
                  _loc9_ += _loc5_.width;
                  _loc3_++;
               }
            }
         }
         if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            _loc10_ = 0;
            _loc11_ = 0;
            _loc2_ = int(this.visibleColumns.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = this.visibleColumns[_loc3_] as DataGridColumn;
               if(_loc5_.resizable)
               {
                  if(!isNaN(_loc5_.explicitWidth))
                  {
                     _loc11_ += _loc5_.width;
                  }
                  else
                  {
                     _loc10_++;
                     _loc11_ += _loc5_.minWidth;
                  }
               }
               else
               {
                  _loc11_ += _loc5_.width;
               }
               _loc4_ += _loc5_.width;
               _loc3_++;
            }
            _loc13_ = availableWidth;
            if(availableWidth > _loc11_ && Boolean(_loc10_))
            {
               _loc2_ = int(this.visibleColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_ = this.visibleColumns[_loc3_] as DataGridColumn;
                  if(_loc5_.resizable && isNaN(_loc5_.explicitWidth))
                  {
                     _loc6_ = _loc5_;
                     if(_loc4_ > availableWidth)
                     {
                        _loc12_ = (_loc6_.width - _loc6_.minWidth) / (_loc4_ - _loc11_);
                     }
                     else
                     {
                        _loc12_ = _loc6_.width / _loc4_;
                     }
                     _loc7_ = _loc6_.width - (_loc4_ - availableWidth) * _loc12_;
                     _loc14_ = _loc5_.minWidth;
                     _loc5_.setWidth(Math.max(_loc7_,_loc14_));
                  }
                  _loc13_ -= _loc5_.width;
                  _loc3_++;
               }
               if(Boolean(_loc13_) && Boolean(_loc6_))
               {
                  _loc6_.setWidth(_loc6_.width + _loc13_);
               }
            }
            else
            {
               _loc2_ = int(this.visibleColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc6_ = this.visibleColumns[_loc3_] as DataGridColumn;
                  _loc12_ = _loc6_.width / _loc4_;
                  _loc7_ = availableWidth * _loc12_;
                  _loc6_.setWidth(_loc7_);
                  _loc6_.explicitWidth = NaN;
                  _loc13_ -= _loc7_;
                  _loc3_++;
               }
               if(Boolean(_loc13_) && Boolean(_loc6_))
               {
                  _loc6_.setWidth(_loc6_.width + _loc13_);
               }
            }
         }
      }
      
      override protected function calculateContentWidth() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:DataGridColumn = null;
         if(this._columns.length == 0)
         {
            contentWidth = 0;
            return;
         }
         if(this.minColumnWidthInvalid)
         {
            _loc1_ = int(this._columns.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._columns[_loc2_] as DataGridColumn;
               _loc3_.minWidth = this.minColumnWidth;
               _loc2_++;
            }
            this.minColumnWidthInvalid = false;
         }
         if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            contentWidth = availableWidth;
         }
         else
         {
            contentWidth = 0;
            _loc1_ = int(this._columns.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._columns[_loc2_] as DataGridColumn;
               if(_loc3_.visible)
               {
                  contentWidth += _loc3_.width;
               }
               _loc2_++;
            }
            if(!isNaN(_horizontalScrollPosition) && _horizontalScrollPosition + availableWidth > contentWidth)
            {
               this.setHorizontalScrollPosition(contentWidth - availableWidth);
            }
         }
      }
      
      protected function handleHeaderRendererClick(param1:MouseEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:DataGridEvent = null;
         if(!_enabled)
         {
            return;
         }
         var _loc2_:HeaderRenderer = param1.currentTarget as HeaderRenderer;
         var _loc3_:uint = _loc2_.column;
         var _loc4_:DataGridColumn = this._columns[_loc3_] as DataGridColumn;
         if(this.sortableColumns && _loc4_.sortable)
         {
            _loc5_ = uint(this._sortIndex);
            this._sortIndex = _loc3_;
            _loc6_ = new DataGridEvent(DataGridEvent.HEADER_RELEASE,false,true,_loc3_,-1,_loc2_,Boolean(_loc4_) ? _loc4_.dataField : null);
            if(!dispatchEvent(_loc6_) || !_selectable)
            {
               this._sortIndex = this.lastSortIndex;
               return;
            }
            this.lastSortIndex = _loc5_;
            this.sortByColumn(_loc3_);
            invalidate(InvalidationType.DATA);
         }
      }
      
      public function resizeColumn(param1:int, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:DataGridColumn = null;
         var _loc8_:DataGridColumn = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(this._columns.length == 0)
         {
            return;
         }
         var _loc3_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(!_loc3_)
         {
            return;
         }
         if(!this.visibleColumns || this.visibleColumns.length == 0)
         {
            _loc3_.setWidth(param2);
            return;
         }
         if(param2 < _loc3_.minWidth)
         {
            param2 = _loc3_.minWidth;
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            _loc3_.setWidth(param2);
            _loc3_.explicitWidth = param2;
         }
         else
         {
            _loc4_ = this.getVisibleColumnIndex(_loc3_);
            if(_loc4_ != -1)
            {
               _loc5_ = 0;
               _loc6_ = int(this.visibleColumns.length);
               _loc9_ = _loc4_ + 1;
               while(_loc9_ < _loc6_)
               {
                  _loc7_ = this.visibleColumns[_loc9_] as DataGridColumn;
                  if(Boolean(_loc7_) && _loc7_.resizable)
                  {
                     _loc5_ += _loc7_.width;
                  }
                  _loc9_++;
               }
               _loc11_ = _loc3_.width - param2 + _loc5_;
               if(Boolean(_loc5_))
               {
                  _loc3_.setWidth(param2);
                  _loc3_.explicitWidth = param2;
               }
               _loc12_ = 0;
               _loc9_ = _loc4_ + 1;
               while(_loc9_ < _loc6_)
               {
                  _loc7_ = this.visibleColumns[_loc9_] as DataGridColumn;
                  if(_loc7_.resizable)
                  {
                     _loc10_ = _loc7_.width * _loc11_ / _loc5_;
                     if(_loc10_ < _loc7_.minWidth)
                     {
                        _loc10_ = _loc7_.minWidth;
                     }
                     _loc7_.setWidth(_loc10_);
                     _loc12_ += _loc7_.width;
                     _loc8_ = _loc7_;
                  }
                  _loc9_++;
               }
               if(_loc12_ > _loc11_)
               {
                  _loc10_ = _loc3_.width - _loc12_ + _loc11_;
                  if(_loc10_ < _loc3_.minWidth)
                  {
                     _loc10_ = _loc3_.minWidth;
                  }
                  _loc3_.setWidth(_loc10_);
               }
               else if(Boolean(_loc8_))
               {
                  _loc8_.setWidth(_loc8_.width - _loc12_ + _loc11_);
               }
            }
            else
            {
               _loc3_.setWidth(param2);
               _loc3_.explicitWidth = param2;
            }
         }
         this.columnsInvalid = true;
         invalidate(InvalidationType.SIZE);
      }
      
      protected function sortByColumn(param1:int) : void
      {
         var _loc2_:DataGridColumn = this.columns[param1] as DataGridColumn;
         if(!enabled || !_loc2_ || !_loc2_.sortable)
         {
            return;
         }
         var _loc3_:Boolean = _loc2_.sortDescending;
         var _loc4_:uint = _loc2_.sortOptions;
         if(_loc3_)
         {
            _loc4_ |= Array.DESCENDING;
         }
         else
         {
            _loc4_ &= ~Array.DESCENDING;
         }
         if(_loc2_.sortCompareFunction != null)
         {
            sortItems(_loc2_.sortCompareFunction,_loc4_);
         }
         else
         {
            sortItemsOn(_loc2_.dataField,_loc4_);
         }
         this._sortDescending = _loc2_.sortDescending = !_loc3_;
         if(this.lastSortIndex >= 0 && this.lastSortIndex != this.sortIndex)
         {
            _loc2_ = this.columns[this.lastSortIndex] as DataGridColumn;
            if(_loc2_ != null)
            {
               _loc2_.sortDescending = false;
            }
         }
      }
      
      protected function createColumnsFromDataProvider() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         this._columns = [];
         if(length > 0)
         {
            _loc1_ = _dataProvider.getItemAt(0);
            for(_loc2_ in _loc1_)
            {
               this.addColumn(_loc2_);
            }
         }
      }
      
      protected function getVisibleColumnIndex(param1:DataGridColumn) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.visibleColumns.length)
         {
            if(param1 == this.visibleColumns[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      protected function handleHeaderResizeOver(param1:MouseEvent) : void
      {
         if(this.columnStretchIndex == -1)
         {
            this.showColumnStretchCursor();
         }
      }
      
      protected function handleHeaderResizeOut(param1:MouseEvent) : void
      {
         if(this.columnStretchIndex == -1)
         {
            this.showColumnStretchCursor(false);
         }
      }
      
      protected function handleHeaderResizeDown(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         var _loc3_:Number = Number(this.dragHandlesMap[_loc2_]);
         var _loc4_:DataGridColumn = this.getColumnAt(_loc3_);
         this.columnStretchIndex = _loc3_;
         this.columnStretchStartX = param1.stageX;
         this.columnStretchStartWidth = _loc4_.width;
         var _loc5_:DisplayObjectContainer = focusManager.form;
         _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.handleHeaderResizeMove,false,0,true);
         _loc5_.addEventListener(MouseEvent.MOUSE_UP,this.handleHeaderResizeUp,false,0,true);
      }
      
      protected function handleHeaderResizeMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.stageX - this.columnStretchStartX;
         var _loc3_:Number = this.columnStretchStartWidth + _loc2_;
         this.resizeColumn(this.columnStretchIndex,_loc3_);
      }
      
      protected function handleHeaderResizeUp(param1:MouseEvent) : void
      {
         var _loc4_:HeaderRenderer = null;
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         var _loc3_:DataGridColumn = this._columns[this.columnStretchIndex] as DataGridColumn;
         var _loc5_:uint = 0;
         while(_loc5_ < this.header.numChildren)
         {
            _loc4_ = this.header.getChildAt(_loc5_) as HeaderRenderer;
            if(Boolean(_loc4_) && _loc4_.column == this.columnStretchIndex)
            {
               break;
            }
            _loc5_++;
         }
         var _loc6_:DataGridEvent = new DataGridEvent(DataGridEvent.COLUMN_STRETCH,false,true,this.columnStretchIndex,-1,_loc4_,Boolean(_loc3_) ? _loc3_.dataField : null);
         dispatchEvent(_loc6_);
         this.columnStretchIndex = -1;
         this.showColumnStretchCursor(false);
         var _loc7_:DisplayObjectContainer = focusManager.form;
         _loc7_.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleHeaderResizeMove,false);
         _loc7_.removeEventListener(MouseEvent.MOUSE_UP,this.handleHeaderResizeUp,false);
      }
      
      protected function showColumnStretchCursor(param1:Boolean = true) : void
      {
         var _loc3_:Point = null;
         if(this.columnStretchCursor == null)
         {
            this.columnStretchCursor = getDisplayObjectInstance(getStyleValue("columnStretchCursorSkin")) as Sprite;
            this.columnStretchCursor.mouseEnabled = false;
         }
         var _loc2_:DisplayObjectContainer = focusManager.form;
         if(param1)
         {
            Mouse.hide();
            _loc2_.addChild(this.columnStretchCursor);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.positionColumnStretchCursor,false,0,true);
            _loc3_ = _loc2_.globalToLocal(new Point(stage.mouseX,stage.mouseY));
            this.columnStretchCursor.x = _loc3_.x;
            this.columnStretchCursor.y = _loc3_.y;
         }
         else
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.positionColumnStretchCursor,false);
            if(_loc2_.contains(this.columnStretchCursor))
            {
               _loc2_.removeChild(this.columnStretchCursor);
            }
            Mouse.show();
         }
      }
      
      protected function positionColumnStretchCursor(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = focusManager.form;
         var _loc3_:Point = _loc2_.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.columnStretchCursor.x = _loc3_.x;
         this.columnStretchCursor.y = _loc3_.y;
      }
      
      protected function setEditedItemPosition(param1:Object) : void
      {
         this.editedItemPositionChanged = true;
         this.proposedEditedItemPosition = param1;
         if(Boolean(param1) && param1.rowIndex != selectedIndex)
         {
            selectedIndex = param1.rowIndex;
         }
         invalidate(InvalidationType.DATA);
      }
      
      protected function commitEditedItemPosition(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(!enabled || !this.editable)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance && param1 && this.itemEditorInstance is IFocusManagerComponent) && Boolean(this._editedItemPosition.rowIndex == param1.rowIndex) && this._editedItemPosition.columnIndex == param1.columnIndex)
         {
            IFocusManagerComponent(this.itemEditorInstance).setFocus();
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            if(!param1)
            {
               _loc4_ = DataGridEventReason.OTHER;
            }
            else if(!this.editedItemPosition || param1.rowIndex == this.editedItemPosition.rowIndex)
            {
               _loc4_ = DataGridEventReason.NEW_COLUMN;
            }
            else
            {
               _loc4_ = DataGridEventReason.NEW_ROW;
            }
            if(!this.endEdit(_loc4_) && _loc4_ != DataGridEventReason.OTHER)
            {
               return;
            }
         }
         this._editedItemPosition = param1;
         if(!param1)
         {
            return;
         }
         this.actualRowIndex = param1.rowIndex;
         this.actualColIndex = param1.columnIndex;
         if(this.displayableColumns.length != this._columns.length)
         {
            _loc5_ = 0;
            while(_loc5_ < this.displayableColumns.length)
            {
               if(this.displayableColumns[_loc5_].colNum >= this.actualColIndex)
               {
                  this.actualColIndex = this.displayableColumns[_loc5_].colNum;
                  break;
               }
               _loc5_++;
            }
            if(_loc5_ == this.displayableColumns.length)
            {
               this.actualColIndex = 0;
            }
         }
         this.scrollToPosition(this.actualRowIndex,this.actualColIndex);
         var _loc2_:ICellRenderer = this.getCellRendererAt(this.actualRowIndex,this.actualColIndex);
         var _loc3_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGIN,false,true,this.actualColIndex,this.actualRowIndex,_loc2_);
         dispatchEvent(_loc3_);
         if(this.editedItemPositionChanged)
         {
            this.editedItemPositionChanged = false;
            this.commitEditedItemPosition(this.proposedEditedItemPosition);
            this.proposedEditedItemPosition = undefined;
         }
         if(!this.itemEditorInstance)
         {
            this.commitEditedItemPosition(null);
         }
      }
      
      protected function itemEditorItemEditBeginningHandler(param1:DataGridEvent) : void
      {
         if(!param1.isDefaultPrevented())
         {
            this.setEditedItemPosition({
               "columnIndex":param1.columnIndex,
               "rowIndex":uint(param1.rowIndex)
            });
         }
         else if(!this.itemEditorInstance)
         {
            this._editedItemPosition = null;
            this.editable = false;
            setFocus();
            this.editable = true;
         }
      }
      
      protected function itemEditorItemEditBeginHandler(param1:DataGridEvent) : void
      {
         var _loc2_:IFocusManager = null;
         addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         if(!param1.isDefaultPrevented())
         {
            this.createItemEditor(param1.columnIndex,uint(param1.rowIndex));
            ICellRenderer(this.itemEditorInstance).listData = ICellRenderer(this.editedItemRenderer).listData;
            ICellRenderer(this.itemEditorInstance).data = this.editedItemRenderer.data;
            this.itemEditorInstance.imeMode = this.columns[param1.columnIndex].imeMode == null ? _imeMode : this.columns[param1.columnIndex].imeMode;
            _loc2_ = focusManager;
            if(this.itemEditorInstance is IFocusManagerComponent)
            {
               _loc2_.setFocus(InteractiveObject(this.itemEditorInstance));
            }
            _loc2_.defaultButtonEnabled = false;
            param1 = new DataGridEvent(DataGridEvent.ITEM_FOCUS_IN,false,false,this._editedItemPosition.columnIndex,this._editedItemPosition.rowIndex,this.itemEditorInstance);
            dispatchEvent(param1);
         }
      }
      
      protected function itemEditorItemEditEndHandler(param1:DataGridEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:IFocusManager = null;
         if(!param1.isDefaultPrevented())
         {
            _loc2_ = false;
            if(Boolean(this.itemEditorInstance) && param1.reason != DataGridEventReason.CANCELLED)
            {
               _loc3_ = this.itemEditorInstance[this._columns[param1.columnIndex].editorDataField];
               _loc4_ = this._columns[param1.columnIndex].dataField;
               _loc5_ = param1.itemRenderer.data;
               _loc6_ = "";
               for each(_loc7_ in describeType(_loc5_).variable)
               {
                  if(_loc4_ == _loc7_.@name.toString())
                  {
                     _loc6_ = _loc7_.@type.toString();
                     break;
                  }
               }
               switch(_loc6_)
               {
                  case "String":
                     if(!(_loc3_ is String))
                     {
                        _loc3_ = _loc3_.toString();
                     }
                     break;
                  case "uint":
                     if(!(_loc3_ is uint))
                     {
                        _loc3_ = uint(_loc3_);
                     }
                     break;
                  case "int":
                     if(!(_loc3_ is int))
                     {
                        _loc3_ = int(_loc3_);
                     }
                     break;
                  case "Number":
                     if(!(_loc3_ is Number))
                     {
                        _loc3_ = Number(_loc3_);
                     }
               }
               if(_loc5_[_loc4_] != _loc3_)
               {
                  _loc2_ = true;
                  _loc5_[_loc4_] = _loc3_;
               }
               param1.itemRenderer.data = _loc5_;
            }
         }
         else if(param1.reason != DataGridEventReason.OTHER)
         {
            if(Boolean(this.itemEditorInstance) && Boolean(this._editedItemPosition))
            {
               if(selectedIndex != this._editedItemPosition.rowIndex)
               {
                  selectedIndex = this._editedItemPosition.rowIndex;
               }
               _loc8_ = focusManager;
               if(this.itemEditorInstance is IFocusManagerComponent)
               {
                  _loc8_.setFocus(InteractiveObject(this.itemEditorInstance));
               }
            }
         }
         if(param1.reason == DataGridEventReason.OTHER || !param1.isDefaultPrevented())
         {
            this.destroyItemEditor();
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:DataGridColumn = null;
         if(param1.target != this)
         {
            return;
         }
         if(this.losingFocus)
         {
            this.losingFocus = false;
            return;
         }
         setIMEMode(true);
         super.focusInHandler(param1);
         if(this.editable && !this.isPressed)
         {
            _loc2_ = this.editedItemPosition != null;
            if(!this._editedItemPosition)
            {
               this._editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
               while(this._editedItemPosition.columnIndex < this._columns.length)
               {
                  _loc3_ = this._columns[this._editedItemPosition.columnIndex] as DataGridColumn;
                  if(_loc3_.editable && _loc3_.visible)
                  {
                     _loc2_ = true;
                     break;
                  }
                  ++this._editedItemPosition.columnIndex;
               }
            }
            if(_loc2_)
            {
               this.setEditedItemPosition(this._editedItemPosition);
            }
         }
         if(this.editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         setIMEMode(false);
         if(param1.target == this)
         {
            super.focusOutHandler(param1);
         }
         if(param1.relatedObject == this && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && this.itemRendererContains(this.editedItemRenderer,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(Boolean(this.itemEditorInstance) && (!param1.relatedObject || !this.itemRendererContains(this.itemEditorInstance,param1.relatedObject)))
         {
            this.endEdit(DataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      protected function editorMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:ICellRenderer = null;
         var _loc3_:uint = 0;
         if(!this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            if(param1.target is ICellRenderer && contains(DisplayObject(param1.target)))
            {
               _loc2_ = param1.target as ICellRenderer;
               _loc3_ = _loc2_.listData.row;
               if(this._editedItemPosition.rowIndex == _loc3_)
               {
                  this.endEdit(DataGridEventReason.NEW_COLUMN);
               }
               else
               {
                  this.endEdit(DataGridEventReason.NEW_ROW);
               }
            }
            else
            {
               this.endEdit(DataGridEventReason.OTHER);
            }
         }
      }
      
      protected function editorKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.ctrlKey && param1.charCode == 46)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.charCode == Keyboard.ENTER && param1.keyCode != 229)
         {
            if(this.endEdit(DataGridEventReason.NEW_ROW))
            {
               this.findNextEnterItemRenderer(param1);
            }
         }
      }
      
      protected function findNextItemRenderer(param1:Boolean) : Boolean
      {
         var _loc7_:String = null;
         var _loc8_:DataGridEvent = null;
         if(!this._editedItemPosition)
         {
            return false;
         }
         if(this.proposedEditedItemPosition !== undefined)
         {
            return false;
         }
         var _loc2_:int = int(this._editedItemPosition.rowIndex);
         var _loc3_:int = int(this._editedItemPosition.columnIndex);
         var _loc4_:Boolean = false;
         var _loc5_:int = param1 ? -1 : 1;
         var _loc6_:int = length - 1;
         while(!_loc4_)
         {
            _loc3_ += _loc5_;
            if(_loc3_ < 0 || _loc3_ >= this._columns.length)
            {
               _loc3_ = _loc3_ < 0 ? int(this._columns.length - 1) : 0;
               _loc2_ += _loc5_;
               if(_loc2_ < 0 || _loc2_ > _loc6_)
               {
                  this.setEditedItemPosition(null);
                  this.losingFocus = true;
                  setFocus();
                  return false;
               }
            }
            if(Boolean(this._columns[_loc3_].editable) && Boolean(this._columns[_loc3_].visible))
            {
               _loc4_ = true;
               if(_loc2_ == this._editedItemPosition.rowIndex)
               {
                  _loc7_ = DataGridEventReason.NEW_COLUMN;
               }
               else
               {
                  _loc7_ = DataGridEventReason.NEW_ROW;
               }
               if(!this.itemEditorInstance || this.endEdit(_loc7_))
               {
                  _loc8_ = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc3_,_loc2_);
                  _loc8_.dataField = this._columns[_loc3_].dataField;
                  dispatchEvent(_loc8_);
               }
            }
         }
         return _loc4_;
      }
      
      protected function findNextEnterItemRenderer(param1:KeyboardEvent) : void
      {
         if(this.proposedEditedItemPosition !== undefined)
         {
            return;
         }
         var _loc2_:int = int(this._editedItemPosition.rowIndex);
         var _loc3_:int = int(this._editedItemPosition.columnIndex);
         var _loc4_:int = this._editedItemPosition.rowIndex + (param1.shiftKey ? -1 : 1);
         if(_loc4_ >= 0 && _loc4_ < length)
         {
            _loc2_ = _loc4_;
         }
         var _loc5_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc3_,_loc2_);
         _loc5_.dataField = this._columns[_loc3_].dataField;
         dispatchEvent(_loc5_);
      }
      
      protected function mouseFocusChangeHandler(param1:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance) && Boolean(!param1.isDefaultPrevented()) && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            param1.preventDefault();
         }
      }
      
      protected function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.keyCode == Keyboard.TAB && !param1.isDefaultPrevented() && this.findNextItemRenderer(param1.shiftKey))
         {
            param1.preventDefault();
         }
      }
      
      private function itemEditorFocusOutHandler(param1:FocusEvent) : void
      {
         if(Boolean(param1.relatedObject) && contains(param1.relatedObject))
         {
            return;
         }
         if(!param1.relatedObject)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
      }
      
      protected function deactivateHandler(param1:Event) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
            this.losingFocus = true;
            setFocus();
         }
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         this.isPressed = true;
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         this.isPressed = false;
      }
      
      override protected function handleCellRendererClick(param1:MouseEvent) : void
      {
         var _loc3_:DataGridColumn = null;
         var _loc4_:DataGridEvent = null;
         super.handleCellRendererClick(param1);
         var _loc2_:ICellRenderer = param1.currentTarget as ICellRenderer;
         if(Boolean(_loc2_) && Boolean(_loc2_.data) && _loc2_ != this.itemEditorInstance)
         {
            _loc3_ = this._columns[_loc2_.listData.column] as DataGridColumn;
            if(Boolean(this.editable) && Boolean(_loc3_) && _loc3_.editable)
            {
               _loc4_ = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc2_.listData.column,_loc2_.listData.row,_loc2_,_loc3_.dataField);
               dispatchEvent(_loc4_);
            }
         }
      }
      
      public function createItemEditor(param1:uint, param2:uint) : void
      {
         var _loc6_:int = 0;
         if(this.displayableColumns.length != this._columns.length)
         {
            _loc6_ = 0;
            while(_loc6_ < this.displayableColumns.length)
            {
               if(this.displayableColumns[_loc6_].colNum >= param1)
               {
                  param1 = uint(this.displayableColumns[_loc6_].colNum);
                  break;
               }
               _loc6_++;
            }
            if(_loc6_ == this.displayableColumns.length)
            {
               param1 = 0;
            }
         }
         var _loc3_:DataGridColumn = this._columns[param1] as DataGridColumn;
         var _loc4_:ICellRenderer = this.getCellRendererAt(param2,param1);
         if(!this.itemEditorInstance)
         {
            this.itemEditorInstance = getDisplayObjectInstance(_loc3_.itemEditor);
            this.itemEditorInstance.tabEnabled = false;
            list.addChild(DisplayObject(this.itemEditorInstance));
         }
         list.setChildIndex(DisplayObject(this.itemEditorInstance),list.numChildren - 1);
         var _loc5_:Sprite = _loc4_ as Sprite;
         this.itemEditorInstance.visible = true;
         this.itemEditorInstance.move(_loc5_.x,_loc5_.y);
         this.itemEditorInstance.setSize(_loc3_.width,this.rowHeight);
         this.itemEditorInstance.drawNow();
         DisplayObject(this.itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,this.itemEditorFocusOutHandler);
         _loc5_.visible = false;
         DisplayObject(this.itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
         focusManager.form.addEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true,0,true);
      }
      
      public function destroyItemEditor() : void
      {
         var _loc1_:DataGridEvent = null;
         if(Boolean(this.itemEditorInstance))
         {
            DisplayObject(this.itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
            focusManager.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true);
            _loc1_ = new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT,false,false,this._editedItemPosition.columnIndex,this._editedItemPosition.rowIndex,this.itemEditorInstance);
            dispatchEvent(_loc1_);
            if(Boolean(this.itemEditorInstance) && this.itemEditorInstance is UIComponent)
            {
               UIComponent(this.itemEditorInstance).drawFocus(false);
            }
            list.removeChild(DisplayObject(this.itemEditorInstance));
            DisplayObject(this.editedItemRenderer).visible = true;
            this.itemEditorInstance = null;
         }
      }
      
      protected function endEdit(param1:String) : Boolean
      {
         if(!this.editedItemRenderer)
         {
            return true;
         }
         var _loc2_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true,this.editedItemPosition.columnIndex,this.editedItemPosition.rowIndex,this.editedItemRenderer,this._columns[this.editedItemPosition.columnIndex].dataField,param1);
         dispatchEvent(_loc2_);
         return !_loc2_.isDefaultPrevented();
      }
      
      public function getCellRendererAt(param1:uint, param2:uint) : ICellRenderer
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:ICellRenderer = null;
         var _loc3_:DataGridColumn = this._columns[param2] as DataGridColumn;
         if(_loc3_ != null)
         {
            _loc4_ = this.activeCellRenderersMap[_loc3_] as Array;
            if(_loc4_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_] as ICellRenderer;
                  if(_loc6_.listData.row == param1)
                  {
                     return _loc6_;
                  }
                  _loc5_++;
               }
            }
         }
         return null;
      }
      
      protected function itemRendererContains(param1:Object, param2:DisplayObject) : Boolean
      {
         if(!param2 || !param1 || !(param1 is DisplayObjectContainer))
         {
            return false;
         }
         return DisplayObjectContainer(param1).contains(param2);
      }
      
      override protected function handleDataChange(param1:DataChangeEvent) : void
      {
         super.handleDataChange(param1);
         if(this._columns == null)
         {
            this._columns = [];
         }
         if(this._columns.length == 0)
         {
            this.createColumnsFromDataProvider();
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!selectable || Boolean(this.itemEditorInstance))
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               this.moveSelectionVertically(param1.keyCode,param1.shiftKey && _allowMultipleSelection,param1.ctrlKey && _allowMultipleSelection);
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               this.moveSelectionHorizontally(param1.keyCode,param1.shiftKey && _allowMultipleSelection,param1.ctrlKey && _allowMultipleSelection);
               break;
            case Keyboard.SPACE:
               if(caretIndex == -1)
               {
                  caretIndex = 0;
               }
               this.scrollToIndex(caretIndex);
               this.doKeySelection(caretIndex,param1.shiftKey,param1.ctrlKey);
         }
         param1.stopPropagation();
      }
      
      override protected function moveSelectionHorizontally(param1:uint, param2:Boolean, param3:Boolean) : void
      {
      }
      
      override protected function moveSelectionVertically(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:int = Math.max(Math.floor(this.calculateAvailableHeight() / this.rowHeight),1);
         var _loc5_:int = -1;
         var _loc6_:int = 0;
         switch(param1)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  _loc5_ = caretIndex - 1;
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < length - 1)
               {
                  _loc5_ = caretIndex + 1;
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex > 0)
               {
                  _loc5_ = Math.max(caretIndex - _loc4_,0);
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < length - 1)
               {
                  _loc5_ = Math.min(caretIndex + _loc4_,length - 1);
               }
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  _loc5_ = 0;
               }
               break;
            case Keyboard.END:
               if(caretIndex < length - 1)
               {
                  _loc5_ = length - 1;
               }
         }
         if(_loc5_ >= 0)
         {
            this.doKeySelection(_loc5_,param2,param3);
            scrollToSelected();
         }
      }
      
      override public function scrollToIndex(param1:int) : void
      {
         var _loc4_:Number = NaN;
         drawNow();
         var _loc2_:int = Math.floor((_verticalScrollPosition + availableHeight) / this.rowHeight) - 1;
         var _loc3_:int = Math.ceil(_verticalScrollPosition / this.rowHeight);
         if(param1 < _loc3_)
         {
            verticalScrollPosition = param1 * this.rowHeight;
         }
         else if(param1 >= _loc2_)
         {
            _loc4_ = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && hScrollBar ? 15 : 0;
            verticalScrollPosition = (param1 + 1) * this.rowHeight - availableHeight + _loc4_ + (this.showHeaders ? this.headerHeight : 0);
         }
      }
      
      protected function scrollToPosition(param1:int, param2:int) : void
      {
         var _loc5_:uint = 0;
         var _loc8_:DataGridColumn = null;
         var _loc3_:Number = verticalScrollPosition;
         var _loc4_:Number = horizontalScrollPosition;
         this.scrollToIndex(param1);
         var _loc6_:Number = 0;
         var _loc7_:DataGridColumn = this._columns[param2] as DataGridColumn;
         _loc5_ = 0;
         while(_loc5_ < this.displayableColumns.length)
         {
            _loc8_ = this.displayableColumns[_loc5_] as DataGridColumn;
            if(_loc8_ == _loc7_)
            {
               break;
            }
            _loc6_ += _loc8_.width;
            _loc5_++;
         }
         if(horizontalScrollPosition > _loc6_)
         {
            horizontalScrollPosition = _loc6_;
         }
         else if(horizontalScrollPosition + availableWidth < _loc6_ + _loc7_.width)
         {
            horizontalScrollPosition = -(availableWidth - (_loc6_ + _loc7_.width));
         }
         if(_loc3_ != verticalScrollPosition || _loc4_ != horizontalScrollPosition)
         {
            drawNow();
         }
      }
      
      protected function doKeySelection(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Boolean = false;
         if(param2)
         {
            _loc6_ = [];
            _loc7_ = lastCaretIndex;
            _loc8_ = param1;
            if(_loc7_ == -1)
            {
               _loc7_ = caretIndex != -1 ? caretIndex : param1;
            }
            if(_loc7_ > _loc8_)
            {
               _loc8_ = _loc7_;
               _loc7_ = param1;
            }
            _loc5_ = _loc7_;
            while(_loc5_ <= _loc8_)
            {
               _loc6_.push(_loc5_);
               _loc5_++;
            }
            selectedIndices = _loc6_;
            caretIndex = param1;
            _loc4_ = true;
         }
         else if(param3)
         {
            caretIndex = param1;
         }
         else
         {
            selectedIndex = param1;
            caretIndex = lastCaretIndex = param1;
            _loc4_ = true;
         }
         if(_loc4_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         invalidate(InvalidationType.DATA);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
   }
}

