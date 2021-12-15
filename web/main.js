import './style.css'
import { AnimationMixer, WebGLRenderer, AmbientLight, Scene, PerspectiveCamera, Clock, DirectionalLight, Box3, SpotLight, SpotLightHelper, CameraHelper, sRGBEncoding, OrthographicCamera, GridHelper, AxesHelper } from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { DRACOLoader } from 'three/examples/jsm/loaders/DRACOLoader';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';


let scene, camera, clock, renderer, mixer, controls, loader, renderedObjects, bbox;


const setupScene = (fov) => {

	scene = new Scene();
	const aspect = window.innerWidth / window.innerHeight;
    camera = new PerspectiveCamera(fov, aspect);
	clock = new Clock();

	renderer = new WebGLRenderer({ alpha: true, antialias: true, });

	renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.shadowMap.enabled = true;
	renderer.physicallyCorrectLights = true;
	renderer.outputEncoding = sRGBEncoding;
	renderer.setClearColor(0xcccccc);

	document.body.appendChild(renderer.domElement);
	controls = new OrbitControls(camera, renderer.domElement);
	
	window.controls = controls;
	window.camera = camera;
}

const setOrbitControls = (polMin, polMax, azMin, azMax) => {
	controls.minPolarAngle = polMin ?? -Infinity;
	controls.maxPolarAngle = polMax ?? Infinity;
	controls.minAzimuthAngle = azMin ?? -Infinity;
	controls.maxAzimuthAngle = azMax ?? -Infinity;
}


const addGridHelper = () => {
    
    var helper = new GridHelper(100, 100);
    helper.rotation.x = Math.PI / 2;
    helper.material.opacity = 1;
    helper.material.transparent = false;
    scene.add(helper);

    var axis = new AxesHelper(1000);
    scene.add(axis);
  }


const setBackgroundColor = (color, alpha) => {
	renderer.setClearColor(color, alpha);
}

const setCameraPosition = (x, y, z) => {
	camera.position.set(x, y, z);
	controls.update();
}

const setCameraRotation = (x, y, z) => {
	camera.rotation.set(x, y, z);
	controls.update();
}

const loadModel = (modelUrl, playAnimation) => {

	return new Promise((res, rej) => {


		// Instantiate a loader
		loader = new GLTFLoader();

		// Optional: Provide a DRACOLoader instance to decode compressed mesh data
		const dracoLoader = new DRACOLoader();
		dracoLoader.setDecoderPath('decoder/');
		dracoLoader.setDecoderConfig({ type: 'js' })
		loader.setDRACOLoader(dracoLoader);

		// Load a glTF resource
		loader.load(
			// resource URL
			modelUrl,
			// called when the resource is loaded
			(gltf) => {

				if (playAnimation) {
					mixer = new AnimationMixer(gltf.scene);
					const action = mixer.clipAction(gltf.animations[0]);
					action.play();

					renderedObjects = gltf.scene.children;
					controls.target = gltf.scene.position;

    				bbox = new Box3().setFromObject(gltf.scene);
				}
				gltf.scene.traverse(function (node) {
					if (node.isMesh) {
						node.castShadow = true;
						node.material.depthWrite = !node.material.transparent;
					}
				});
				scene.add(gltf.scene);
				console.log(scene);

				animate();

				res(gltf);
			},
			// called while loading is progressing
			(xhr) => {
				console.log((xhr.loaded / xhr.total * 100) + '% loaded');
				window.onObjectLoading((xhr.loaded / xhr.total * 100));
			},
			// called when loading has errors
			(error) => {
				console.log('An error happened', error);
				window.onLoadError(error);
				rej(error);
			}
		);

	})

}

const lockTarget = () => {
	controls.target = renderedObjects[1]?.position;
}

const addAmbientLight = (color, intensity) => {
	const ambient = new AmbientLight(color, intensity);
	scene.add(ambient);
}

const addDirectionalLight = (color, intensity, pos) => {
    const light2  = new DirectionalLight(color, intensity ?? 0.8 * Math.PI);
    light2.position.set(pos?.x ?? 0.5, pos?.y ?? 0, pos?.z ?? 0.866);
    scene.add( light2 );
}

const animate = () => {
	requestAnimationFrame(animate);
	var delta = clock.getDelta();
	if (mixer) mixer.update(delta);
    controls.update();
	renderer.render(scene, camera);
}

window.setupScene = setupScene;
window.setOrbitControls = setOrbitControls;
window.loadModel = loadModel;
window.addGridHelper = addGridHelper;
window.addAmbientLight = addAmbientLight;
window.addDirectionalLight = addDirectionalLight;
window.setCameraPosition = setCameraPosition;
window.setCameraRotation = setCameraRotation;
window.setBackgroundColor = setBackgroundColor;
window.lockTarget = lockTarget;