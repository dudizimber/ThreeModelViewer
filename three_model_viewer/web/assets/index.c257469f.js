import{S as h,P as p,W as L,s as C,O as b,G as y,D as A,A as O,a as D,b as P,C as v}from"./vendor.141b9991.js";const S=function(){const r=document.createElement("link").relList;if(r&&r.supports&&r.supports("modulepreload"))return;for(const t of document.querySelectorAll('link[rel="modulepreload"]'))d(t);new MutationObserver(t=>{for(const e of t)if(e.type==="childList")for(const i of e.addedNodes)i.tagName==="LINK"&&i.rel==="modulepreload"&&d(i)}).observe(document,{childList:!0,subtree:!0});function n(t){const e={};return t.integrity&&(e.integrity=t.integrity),t.referrerpolicy&&(e.referrerPolicy=t.referrerpolicy),t.crossorigin==="use-credentials"?e.credentials="include":t.crossorigin==="anonymous"?e.credentials="omit":e.credentials="same-origin",e}function d(t){if(t.ep)return;t.ep=!0;const e=n(t);fetch(t.href,e)}};S();let c,s,m,a,u,l,w,f;const k=o=>{c=new h,s=new p(o,window.innerWidth/window.innerHeight,.1,1e3),m=new v,a=new L({alpha:!0,antialias:!0}),a.physicallyCorrectLights=!0,a.outputEncoding=C,a.setClearColor(13421772),a.setSize(window.innerWidth,window.innerHeight),document.body.appendChild(a.domElement),l=new b(s,a.domElement)},E=(o,r)=>{a.setClearColor(o,r)},M=(o,r,n)=>{s.position.set(o,r,n),l.update()},R=(o,r,n)=>{s.rotation.set(o,r,n),l.update()},W=(o,r)=>new Promise((n,d)=>{w=new y;const t=new A;t.setDecoderPath("decoder/"),t.setDecoderConfig({type:"js"}),w.setDRACOLoader(t),w.load(o,e=>{r&&(u=new O(e.scene),u.clipAction(e.animations[0]).play(),f=e.scene.children),e.scene.traverse(function(i){i.isMesh&&(i.castShadow=!0,i.material.depthWrite=!i.material.transparent)}),c.add(e.scene),console.log(c),g(),n(e)},e=>{console.log(e.loaded/e.total*100+"% loaded"),window.onObjectLoading(e.loaded/e.total*100)},e=>{console.log("An error happened",e),window.onLoadError(e),d(e)})}),j=()=>{var o;l.target=(o=f[0])==null?void 0:o.position},G=(o,r)=>{const n=new D(o,r);c.add(n)},B=(o,r,n)=>{var t,e,i;const d=new P(o,r!=null?r:.8*Math.PI);d.position.set((t=n==null?void 0:n.x)!=null?t:.5,(e=n==null?void 0:n.y)!=null?e:0,(i=n==null?void 0:n.z)!=null?i:.866),c.add(d)},g=()=>{requestAnimationFrame(g);var o=m.getDelta();u&&u.update(o),l.update(),a.render(c,s)};window.setupScene=k;window.loadModel=W;window.addAmbientLight=G;window.addDirectionalLight=B;window.setCameraPosition=M;window.setCameraRotation=R;window.setBackgroundColor=E;window.lockTarget=j;