(function(){
  var Rotation, Scene, Control;
  Rotation = (function(){
    Rotation.displayName = 'Rotation';
    var prototype = Rotation.prototype, constructor = Rotation;
    function Rotation(){
      this.targetRotation = 0;
      this.targetRotationOnMouseDown = 0;
      this.mouse = 0;
      this.mouseOnMouseDown = 0;
    }
    prototype.focus = __curry(function(offset){
      this.mouseOnMouseDown = offset;
      return this.targetRotationOnMouseDown = this.targetRotation;
    });
    prototype.rotate = __curry(function(offset){
      return this.targetRotation = this.targetRotationOnMouseDown + (offset - this.mouseOnMouseDown) * 0.02;
    });
    return Rotation;
  }());
  Scene = (function(){
    Scene.displayName = 'Scene';
    var prototype = Scene.prototype, constructor = Scene;
    function Scene(width, height){
      this.width = width;
      this.height = height;
      this.windowHalfX = width / 2;
      this.windowHalfY = height / 2;
      this.scene = new THREE.Scene();
      this.camera = this.init_camera(this.scene);
      this.cube = this.init_cube(this.scene);
      this.plane = this.init_plane(this.scene);
      this.renderer = this.init_renderer(this.scene);
      this.rotationX = new Rotation();
      this.rotationY = new Rotation();
    }
    prototype.dom = __curry(function(){
      return this.renderer.domElement;
    });
    prototype.animate = __curry(function(requestAnimationFrame){
      var self, wtf;
      self = this;
      wtf = function(){
        return self.animate(requestAnimationFrame);
      };
      requestAnimationFrame(wtf);
      this.plane.rotation.y = this.cube.rotation.y += (this.rotationX.targetRotation - this.cube.rotation.y) * 0.05;
      this.plane.rotation.x = this.cube.rotation.x += (this.rotationY.targetRotation - this.cube.rotation.x) * 0.05;
      return this.renderer.render(this.scene, this.camera);
    });
    prototype.init_camera = __curry(function(scene){
      var camera;
      camera = new THREE.PerspectiveCamera(70, this.width / this.height, 1, 1000);
      camera.position.y = 150;
      camera.position.z = 500;
      scene.add(camera);
      return camera;
    });
    prototype.init_cube = __curry(function(scene){
      var materials, cube;
      materials = map(function(){
        return new THREE.MeshBasicMaterial({
          color: Math.random() * 0xffffff
        });
      }, [0, 1, 2, 3, 4, 5]);
      cube = new THREE.Mesh(new THREE.CubeGeometry(200, 200, 200, 1, 1, 1, materials), new THREE.MeshFaceMaterial);
      cube.position.y = 150;
      scene.add(cube);
      return cube;
    });
    prototype.init_plane = __curry(function(scene){
      var plane;
      plane = new THREE.Mesh(new THREE.PlaneGeometry(200, 200), new THREE.MeshBasicMaterial({
        color: 0xe0e0e0
      }));
      scene.add(plane);
      return plane;
    });
    prototype.init_renderer = __curry(function(scene){
      var renderer;
      renderer = new THREE.CanvasRenderer;
      renderer.setSize(this.width, this.height);
      return renderer;
    });
    return Scene;
  }());
  Control = (function(){
    Control.displayName = 'Control';
    var prototype = Control.prototype, constructor = Control;
    function Control(scene, document){
      var self, wtf0;
      this.scene = scene;
      this.document = document;
      self = this;
      wtf0 = function(event){
        return self.onMouseDown(event);
      };
      this.document.addEventListener('mousedown', wtf0, false);
    }
    prototype.enable_listener = __curry(function(){
      return this.process_listener('addEventListener');
    });
    prototype.clear_listener = __curry(function(){
      return this.process_listener('removeEventListener');
    });
    prototype.process_listener = __curry(function(method){
      var self, wtf0, wtf1, wtf2;
      self = this;
      wtf0 = function(event){
        return self.onMouseMove(event);
      };
      wtf1 = function(event){
        return self.onMouseUp(event);
      };
      wtf2 = function(event){
        return self.onMouseOut(event);
      };
      this.document[method]('mousemove', wtf0, false);
      this.document[method]('mouseup', wtf1, false);
      return this.document[method]('mouseout', wtf2, false);
    });
    prototype.onMouseDown = __curry(function(event){
      event.preventDefault();
      this.enable_listener();
      this.scene.rotationX.focus(event.clientX - this.scene.windowHalfX);
      return this.scene.rotationY.focus(event.clientY - this.scene.windowHalfY);
    });
    prototype.onMouseMove = __curry(function(event){
      this.scene.rotationX.rotate(event.clientX - this.scene.windowHalfX);
      return this.scene.rotationY.rotate(event.clientY - this.scene.windowHalfY);
    });
    prototype.onMouseUp = __curry(function(event){
      return this.clear_listener();
    });
    prototype.onMouseOut = __curry(function(event){
      return this.clear_listener();
    });
    return Control;
  }());
  if (typeof window != 'undefined' && window !== null) {
    __import(this, prelude);
    window.Scene = Scene;
    window.Control = Control;
  } else {
    __import(global, require('prelude-ls'));
  }
  function __curry(f, args){
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      return params.push.apply(params, arguments) < f.length && arguments.length ?
        __curry.call(this, f, params) : f.apply(this, params);
    } : f;
  }
  function __import(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
