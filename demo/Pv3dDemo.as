package {
	import flash.events.Event;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.BasicView;
	
	import com.as3dmod.ModifierStack;
	import com.as3dmod.plugins.pv3d.LibraryPv3d;		

	public class Pv3dDemo extends BasicView {
		
		private var c:DisplayObject3D;
		private var m:ModifierStack;
		private var base:DemoBase;
		public function Pv3dDemo(base:DemoBase) {
			this.base = base;
			var mt:CompositeMaterial = new CompositeMaterial();
			mt.addMaterial(new ColorMaterial(0x27590e));
			mt.addMaterial(new WireframeMaterial(0x49a51c));
			mt.doubleSided = true;
			
			//c = new Plane(mt, 1200, 500, 24, 10);
			//c.rotationX = 60;
			//c.rotationY = 45;
			//scene.addChild(c);

			
			
			var ml:MaterialsList = new MaterialsList();
//			var wm:ColorMaterial = new ColorMaterial(0xff0000);			var wm:WireframeMaterial = new WireframeMaterial();
			ml.addMaterial(wm, "all");
//			c = new Cube(ml, 400, 400, 400, 12, 12, 12);			c = new Cube(ml, 300, 300, 700, 5, 20, 5);
			c.rotationY = 45;
			scene.addChild(c);
			
			m = new ModifierStack(new LibraryPv3d(), c);
			base.setupStack(m);
			startRendering();
		}

		protected override function onRenderTick(event:Event = null):void {
			base.onRender();
			super.onRenderTick(event);
			m.apply();
//			c.rotationY += 1;
		}
	}
}





