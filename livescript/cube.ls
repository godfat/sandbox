
class Rotation
  ->
    @targetRotation = 0
    @targetRotationOnMouseDown = 0
    @mouse = 0
    @mouseOnMouseDown = 0

  focus(offset):
    @mouseOnMouseDown = offset
    @targetRotationOnMouseDown = @targetRotation

  rotate(offset):
    @targetRotation =
      @targetRotationOnMouseDown + (offset - @mouseOnMouseDown) * 0.02

class Scene
  (width, height) ->
    @width       = width
    @height      = height
    @windowHalfX = width  / 2
    @windowHalfY = height / 2
    @scene       = new THREE.Scene()
    @camera      = @init_camera   @scene
    @cube        = @init_cube     @scene
    @plane       = @init_plane    @scene
    @renderer    = @init_renderer @scene
    @rotationX   = new Rotation()
    @rotationY   = new Rotation()

  dom(): @renderer.domElement

  animate(requestAnimationFrame):
    self = this
    wtf = -> self.animate(requestAnimationFrame)
    requestAnimationFrame(wtf)
    @plane.rotation.y = @cube.rotation.y +=
        (@rotationX.targetRotation - @cube.rotation.y) * 0.05
    @plane.rotation.x = @cube.rotation.x +=
        (@rotationY.targetRotation - @cube.rotation.x) * 0.05
    @renderer.render(@scene, @camera)

  init_camera(scene):
    camera = new THREE.PerspectiveCamera(70, @width / @height, 1, 1000)
    camera.position.y = 150
    camera.position.z = 500
    scene.add camera
    camera

  init_cube(scene):
    materials =
      map(
        (-> new THREE.MeshBasicMaterial({color: Math.random() * 0xffffff})),
        [0 to 5])

    cube =
      new THREE.Mesh(
        new THREE.CubeGeometry(200, 200, 200, 1, 1, 1, materials),
        new THREE.MeshFaceMaterial)
    cube.position.y = 150
    scene.add cube
    cube

  init_plane(scene):
    plane =
      new THREE.Mesh(
        new THREE.PlaneGeometry(200, 200),
        new THREE.MeshBasicMaterial({color: 0xe0e0e0}))
    scene.add plane
    plane

  init_renderer(scene):
    renderer = new THREE.CanvasRenderer
    renderer.setSize(@width, @height)
    renderer

class Control
  (scene, document) ->
    @scene    = scene
    @document = document
    self = this
    wtf0 = (event) -> self.onMouseDown(event)
    @document.addEventListener(\mousedown, wtf0, false)

  enable_listener():
    @process_listener(\addEventListener)

  # this doesn't work because wtf0 is different!
  # this is too stupid so i am not going to fix it
  clear_listener():
    @process_listener(\removeEventListener)

  process_listener(method):
    self = this
    wtf0 = (event) -> self.onMouseMove(event)
    wtf1 = (event) -> self.onMouseUp(event)
    wtf2 = (event) -> self.onMouseOut(event)
    @document[method](\mousemove, wtf0, false)
    @document[method](\mouseup  , wtf1, false)
    @document[method](\mouseout , wtf2, false)

  onMouseDown(event):
    event.preventDefault()
    @enable_listener()
    @scene.rotationX.focus(event.clientX - @scene.windowHalfX)
    @scene.rotationY.focus(event.clientY - @scene.windowHalfY)

  onMouseMove(event):
    @scene.rotationX.rotate(event.clientX - @scene.windowHalfX)
    @scene.rotationY.rotate(event.clientY - @scene.windowHalfY)

  onMouseUp(event): @clear_listener()
  onMouseOut(event): @clear_listener()

if window?
  import prelude
  window.Scene = Scene
  window.Control = Control
else
  global <<< require \prelude-ls
