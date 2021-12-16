import { S as Scene, W as WebGLRenderer, s as sRGBEncoding, P as PerspectiveCamera, O as OrbitControls, G as GridHelper, A as AxesHelper, a as GLTFLoader, D as DRACOLoader, b as AnimationMixer, c as AmbientLight, d as DirectionalLight, C as Clock } from "./vendor.ce91c239.js";
const p = function polyfill() {
  const relList = document.createElement("link").relList;
  if (relList && relList.supports && relList.supports("modulepreload")) {
    return;
  }
  for (const link of document.querySelectorAll('link[rel="modulepreload"]')) {
    processPreload(link);
  }
  new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      if (mutation.type !== "childList") {
        continue;
      }
      for (const node of mutation.addedNodes) {
        if (node.tagName === "LINK" && node.rel === "modulepreload")
          processPreload(node);
      }
    }
  }).observe(document, { childList: true, subtree: true });
  function getFetchOpts(script) {
    const fetchOpts = {};
    if (script.integrity)
      fetchOpts.integrity = script.integrity;
    if (script.referrerpolicy)
      fetchOpts.referrerPolicy = script.referrerpolicy;
    if (script.crossorigin === "use-credentials")
      fetchOpts.credentials = "include";
    else if (script.crossorigin === "anonymous")
      fetchOpts.credentials = "omit";
    else
      fetchOpts.credentials = "same-origin";
    return fetchOpts;
  }
  function processPreload(link) {
    if (link.ep)
      return;
    link.ep = true;
    const fetchOpts = getFetchOpts(link);
    fetch(link.href, fetchOpts);
  }
};
p();
var style = "";
let scene, camera, clock, renderer, mixer, controls, loader, renderedObjects;
const setupScene = () => {
  scene = new Scene();
  clock = new Clock();
  renderer = new WebGLRenderer({ alpha: true, antialias: true });
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.shadowMap.enabled = true;
  renderer.physicallyCorrectLights = true;
  renderer.outputEncoding = sRGBEncoding;
  renderer.setClearColor(13421772);
  document.body.appendChild(renderer.domElement);
  setCamera();
};
const setCamera = () => {
  camera = new PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 1e3);
  camera.position.set(1, 0, 5);
  window.camera = camera;
  createControls(camera);
};
const createControls = (camera2) => {
  controls = new OrbitControls(camera2, renderer.domElement);
  controls.enablePan = false;
  controls.enableRotate = true;
  controls.enableZoom = false;
  controls.target.set(0.05, 1.24, 0.14);
  controls.update();
  animate();
  window.controls = controls;
};
const setOrbitControls = (polMin, polMax, azMin, azMax) => {
  if (!controls) {
    if (!camera) {
      setTimeout(() => setOrbitControls(polMin, polMax, azMin, azMax), 100);
    } else
      createControls(camera);
    return;
  }
  controls.minPolarAngle = polMin != null ? polMin : -Infinity;
  controls.maxPolarAngle = polMax != null ? polMax : Infinity;
  controls.minAzimuthAngle = azMin != null ? azMin : -Infinity;
  controls.maxAzimuthAngle = azMax != null ? azMax : -Infinity;
};
const addGridHelper = () => {
  var helper = new GridHelper(100, 100);
  helper.rotation.x = Math.PI / 2;
  helper.material.opacity = 1;
  helper.material.transparent = false;
  scene.add(helper);
  var axis = new AxesHelper(1e3);
  scene.add(axis);
};
const setBackgroundColor = (color, alpha) => {
  renderer.setClearColor(color, alpha);
};
const setCameraPosition = (x, y, z) => {
  camera.position.set(x, y, z);
  controls.update();
};
const setCameraRotation = (x, y, z) => {
  camera.rotation.set(x, y, z);
  controls.update();
};
const loadModel = (modelUrl, playAnimation) => {
  return new Promise((res, rej) => {
    loader = new GLTFLoader();
    const dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath("decoder/");
    dracoLoader.setDecoderConfig({ type: "js" });
    loader.setDRACOLoader(dracoLoader);
    loader.load(modelUrl, (gltf) => {
      if (playAnimation) {
        mixer = new AnimationMixer(gltf.scene);
        const action = mixer.clipAction(gltf.animations[0]);
        action.play();
        renderedObjects = gltf.scene.children;
      }
      gltf.scene.traverse(function(node) {
        if (node.isMesh) {
          node.castShadow = true;
          node.material.depthWrite = !node.material.transparent;
        }
      });
      scene.add(gltf.scene);
      console.log(scene);
      res(gltf);
    }, (xhr) => {
      console.log(xhr.loaded / xhr.total * 100 + "% loaded");
      window.onObjectLoading(xhr.loaded / xhr.total * 100);
    }, (error) => {
      console.log("An error happened", error);
      window.onLoadError(error);
      rej(error);
    });
  });
};
const loadCam = (modelUrl) => {
  return new Promise((res, rej) => {
    loader = new GLTFLoader();
    const dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath("decoder/");
    dracoLoader.setDecoderConfig({ type: "js" });
    loader.setDRACOLoader(dracoLoader);
    loader.load(modelUrl, (gltf) => {
      setCamera(gltf.cameras[0]);
      animate();
      res(gltf);
    }, (xhr) => {
      console.log(xhr.loaded / xhr.total * 100 + "% loaded");
      window.onObjectLoading(xhr.loaded / xhr.total * 100);
    }, (error) => {
      console.log("An error happened", error);
      window.onLoadError(error);
      rej(error);
    });
  });
};
const lockTarget = () => {
  var _a;
  controls.target = (_a = renderedObjects[1]) == null ? void 0 : _a.position;
};
const addAmbientLight = (color, intensity) => {
  const ambient = new AmbientLight(color, intensity);
  scene.add(ambient);
};
const addDirectionalLight = (color, intensity, pos) => {
  var _a, _b, _c;
  const light2 = new DirectionalLight(color, intensity != null ? intensity : 0.8 * Math.PI);
  light2.position.set((_a = pos == null ? void 0 : pos.x) != null ? _a : 0.5, (_b = pos == null ? void 0 : pos.y) != null ? _b : 0, (_c = pos == null ? void 0 : pos.z) != null ? _c : 0.866);
  scene.add(light2);
};
const animate = () => {
  requestAnimationFrame(animate);
  var delta = clock.getDelta();
  if (mixer)
    mixer.update(delta);
  if (controls)
    controls.update();
  renderer.render(scene, camera);
};
window.setupScene = setupScene;
window.setOrbitControls = setOrbitControls;
window.loadModel = loadModel;
window.loadCam = loadCam;
window.addGridHelper = addGridHelper;
window.addAmbientLight = addAmbientLight;
window.addDirectionalLight = addDirectionalLight;
window.setCameraPosition = setCameraPosition;
window.setCameraRotation = setCameraRotation;
window.setBackgroundColor = setBackgroundColor;
window.lockTarget = lockTarget;
window.setCamera = setCamera;
