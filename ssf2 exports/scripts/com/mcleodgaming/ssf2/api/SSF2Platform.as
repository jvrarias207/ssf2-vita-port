package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.platforms.MovingPlatform;
   import flash.geom.Point;
   
   public class SSF2Platform extends SSF2CollisionBoundary
   {
      
      private var _ownerCasted:MovingPlatform;
      
      public function SSF2Platform(api:Class, owner:MovingPlatform)
      {
         super(api,owner);
         this._ownerCasted = MovingPlatform(owner);
      }
      
      public function faceRight() : void
      {
         this._ownerCasted.faceRight();
      }
      
      public function faceLeft() : void
      {
         this._ownerCasted.faceLeft();
      }
      
      public function setForeground(id:String) : void
      {
         this._ownerCasted.foreground = id;
      }
      
      public function getFallthrough() : Boolean
      {
         return this._ownerCasted.fallthrough;
      }
      
      public function setFallthrough(value:Boolean) : void
      {
         this._ownerCasted.fallthrough = value;
      }
      
      public function getNoDropThrough() : Boolean
      {
         return this._ownerCasted.noDropThrough;
      }
      
      public function setNoDropThrough(value:Boolean) : void
      {
         this._ownerCasted.noDropThrough = value;
      }
      
      public function getAccelFriction() : Number
      {
         return this._ownerCasted.accel_friction;
      }
      
      public function setAccelFriction(value:Number) : void
      {
         this._ownerCasted.accel_friction = value;
      }
      
      public function getDecelFriction() : Number
      {
         return this._ownerCasted.decel_friction;
      }
      
      public function setDecelFriction(value:Number) : void
      {
         this._ownerCasted.decel_friction = value;
      }
      
      public function get XInfluence() : Number
      {
         return this._ownerCasted.x_influence;
      }
      
      public function set XInfluence(value:Number) : void
      {
         this._ownerCasted.x_influence = value;
      }
      
      public function getDanger() : Boolean
      {
         return this._ownerCasted.danger;
      }
      
      public function setDanger(value:Boolean) : void
      {
         this._ownerCasted.danger = value;
      }
      
      public function getBounceSpeed() : Number
      {
         return this._ownerCasted.bounce_speed;
      }
      
      public function setBounceSpeed(value:Number) : void
      {
         this._ownerCasted.bounce_speed = value;
      }
      
      public function setAlpha(val:Number) : void
      {
         this._ownerCasted.setAlpha(val);
      }
      
      public function setCamFocus(value:Boolean) : void
      {
         this._ownerCasted.setCamFocus(value);
      }
      
      public function getXSpeed() : Number
      {
         return this._ownerCasted.getXSpeed();
      }
      
      public function setXSpeed(value:Number) : void
      {
         this._ownerCasted.setXSpeed(value);
      }
      
      public function getYSpeed() : Number
      {
         return this._ownerCasted.getYSpeed();
      }
      
      public function setYSpeed(value:Number) : void
      {
         this._ownerCasted.setYSpeed(value);
      }
      
      public function getStartPosition() : Point
      {
         return this._ownerCasted.getStartPosition();
      }
      
      public function addMovement(movement:Object) : void
      {
         this._ownerCasted.addMovement(movement);
      }
      
      public function clearMovement() : void
      {
         this._ownerCasted.clearMovement();
      }
      
      public function getConserveHorizontalMomentum() : Boolean
      {
         return this._ownerCasted.conserve_horizontal_momentum;
      }
      
      public function setConserveHorizontalMomentum(value:Boolean) : void
      {
         this._ownerCasted.conserve_horizontal_momentum = value;
      }
      
      public function getConserveUpwardMomentum() : Boolean
      {
         return this._ownerCasted.conserve_upward_momentum;
      }
      
      public function setConserveUpwardMomentum(value:Boolean) : void
      {
         this._ownerCasted.conserve_upward_momentum = value;
      }
      
      public function getConserveDownwardMomentum() : Boolean
      {
         return this._ownerCasted.conserve_downward_momentum;
      }
      
      public function setConserveDownwardMomentum(value:Boolean) : void
      {
         this._ownerCasted.conserve_downward_momentum = value;
      }
      
      public function extraHitTests(x_offset:Number, y_offset:Number, caller:InteractiveSprite) : Boolean
      {
         if(Boolean(caller.APIInstance) && Boolean(_api) && "extraHitTests" in _api)
         {
            return _api.extraHitTests(x_offset,y_offset,caller.APIInstance.instance);
         }
         return false;
      }
      
      public function addIgnoreObject(obj:*) : void
      {
         var casted:InteractiveSprite = null;
         if("$ext" in obj && obj.$ext.getAPI().owner is InteractiveSprite)
         {
            casted = obj.$ext.getAPI().owner;
            if(this._ownerCasted.IgnoreList.indexOf(casted) < 0)
            {
               this._ownerCasted.IgnoreList.push(casted);
            }
         }
      }
      
      public function removeIgnoreObject(obj:*) : void
      {
         var casted:InteractiveSprite = null;
         var index:int = 0;
         if("$ext" in obj && obj.$ext.getAPI().owner is InteractiveSprite)
         {
            casted = obj.$ext.getAPI().owner;
            index = this._ownerCasted.IgnoreList.indexOf(casted);
            if(index >= 0)
            {
               this._ownerCasted.IgnoreList.splice(index,1);
            }
         }
      }
      
      public function setIgnoreObjectListInversed(inversed:Boolean) : void
      {
         this._ownerCasted.setIgnoreObjectListInversed(inversed);
      }
   }
}

