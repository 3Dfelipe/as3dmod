package com.as3dmod.modifiers {
	import com.as3dmod.IModifier;
	import com.as3dmod.core.MeshProxy;
	import com.as3dmod.core.Modifier;
	import com.as3dmod.core.VertexProxy;
	import com.as3dmod.util.ModConstant;	

	/**
	 * 	Paper works like Bend, but enables to put the bend axis at any angle.
	 * 	 
	 * 	Once properly tested it will replace the bend modifier in future verions.
	 * 	
	 * 	@author Bartek Drozdz
	 */
	public class Paper extends Modifier implements IModifier {
		
		private var _force:Number;
		private var _offset:Number;
		private var _angle:Number;
		private var _diagAngle:Number;
		
		private var _constraint:int = ModConstant.NONE;
		
		private var max:int;
		private var min:int;		private var mid:int;
		private var width:Number;
		private var height:Number;
		private var origin:Number;
		private var switchAxes:Boolean;

		public function Paper(f:Number=0, o:Number=.5, a:Number=0, switchAxes:Boolean=false) {
			_force = f;
			_offset = o;
			_angle = a;
			this.switchAxes = switchAxes;
		}

		override public function setModifiable(mod:MeshProxy):void {
			super.setModifiable(mod);
			max = (switchAxes) ? mod.midAxis : mod.maxAxis;
			min = mod.minAxis;
			mid = (switchAxes) ? mod.maxAxis : mod.midAxis;
			
			width = mod.getSize(max);	
			height = mod.getSize(mid);
			origin = mod.getMin(max);
			
			_diagAngle = Math.atan(width / height);
		}

		/**
		 * 	[0 - 2] where 0 = no bend, and 2 360 deg bend.
		 * 	When > 2 will start rolling on itself, which does not look good.
		 * 	(default - 0)
		 */
		public function set force(f:Number):void { _force = f; }		
		public function get force():Number { return _force; }
		
		/**
		 * Can be either ModConstants.LEFT, ModConstants.RIGHT or ModConstants.NONE
		 * (default - NONE)
		 */
		public function set constraint(c:int):void { _constraint = c; }
		public function get constraint():int { return _constraint; }
		
		/**
		 * [0 - 1] The start place of the bend. 
		 */
		public function get offset():Number { return _offset; }
		public function set offset(offset:Number):void { _offset = offset; }

		/**
		 * 	The angle of the diagonal of the mesh
		 */
		public function get diagAngle():Number { return _diagAngle; }
		
		/**
		 * The angle of the bend. In rad.
		 */
		public function get angle():Number { return _angle; }
		public function set angle(angle:Number):void { _angle = angle; }

		/**
		 *  Applies the modifier to the mesh
		 */
		public function apply():void {	
			if(force == 0) return;

			var vs:Array = mod.getVertices();
			var vc:int = vs.length;
			
			var distance:Number = origin + width * offset;
			var radius:Number = width / Math.PI / force;
			var bendAngle:Number = Math.PI * 2 * (width / (radius * Math.PI * 2));

			for (var i:int = 0; i < vc; i++) {
				var v:VertexProxy = vs[i] as VertexProxy;
				
				var vmax:Number = v.getValue(max);				var vmid:Number = v.getValue(mid);				var vmin:Number = v.getValue(min);

				var vmax2:Number = Math.cos(_angle) * vmax - Math.sin(_angle) * vmid;				var vmid2:Number = Math.cos(_angle) * vmid + Math.sin(_angle) * vmax;
				
				vmax = vmax2;
				vmid = vmid2;
				
				
				var p:Number = (vmax - origin) / width;
				
				if ((constraint == ModConstant.LEFT && p <= offset) || (constraint == ModConstant.RIGHT && p >= offset)) {	
				} else {
					var fa:Number = ((Math.PI / 2) - bendAngle * offset) + (bendAngle * p);
					var op:Number = Math.sin(fa) * (radius + vmin);
					var ow:Number = Math.cos(fa) * (radius + vmin);
					vmin = op - radius;
					vmax = distance - ow;
				}

				vmax2 = Math.cos(-_angle) * vmax - Math.sin(-_angle) * vmid;
				vmid2 = Math.cos(-_angle) * vmid + Math.sin(-_angle) * vmax;
				
				vmax = vmax2;
				vmid = vmid2;
				
				v.setValue(max, vmax);
				v.setValue(mid, vmid);				v.setValue(min, vmin);
			}
		}
	}
}


