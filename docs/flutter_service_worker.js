'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "2b0d1e92c964491e3c5bab8736c31267",
"/": "2b0d1e92c964491e3c5bab8736c31267",
"main.dart.js": "79d1d8d10d6a37d2bdb1eff39c42ae71",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "bd6d9574c9753f2b3012d14f5ee441fb",
"assets/LICENSE": "4f8ffe5b550fc2742f681e9acdc8f925",
"assets/AssetManifest.json": "6a571b37bc0a2a8b8d1e70348d2a8b5d",
"assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/images/playeranim.png": "e02f0628517e2a0acaa7ab1df2364ffd",
"assets/assets/images/player.png": "dff2c9a939a81491a1a5a7fbfa4c7f30",
"assets/assets/images/player/idle/Idle%2520(1).png": "637f97f026660a181bfbbee7fc3f5e8f",
"assets/assets/images/player/idle/Idle%2520(7).png": "5bc8c368ad438d5e5764303ff7aca2e9",
"assets/assets/images/player/idle/Idle%2520(6).png": "b70ca9329fe1fb7d01e79be4fc917ab1",
"assets/assets/images/player/idle/Idle%2520(9).png": "4dd5b6ca5b78a6ca5221bfc6f464adb5",
"assets/assets/images/player/idle/Idle%2520(5).png": "d690f5dacdf3a95800cb36c3598bac04",
"assets/assets/images/player/idle/Idle%2520(4).png": "a141c632d9a1987b388ce4535dbbaf2a",
"assets/assets/images/player/idle/Idle%2520(8).png": "8b093a3fae0031dd75c2849c132017d4",
"assets/assets/images/player/idle/Idle%2520(3).png": "821e1a08f829caa26b5d680908c9fbe1",
"assets/assets/images/player/idle/Idle%2520(10).png": "f50d5025ff967dddfca6ac5514dacfb6",
"assets/assets/images/player/idle/Idle%2520(2).png": "0da5f1f0cdc9e9bacdd8d6884870d71a",
"assets/assets/images/player/run/Run%2520(1).png": "12b04c25f6727159cb057a63e2c9bd39",
"assets/assets/images/player/run/Run%2520(6).png": "c7d8af0f6f78d7b8cc14d0be9bdd3c3a",
"assets/assets/images/player/run/Run%2520(7).png": "60900773ac3b720ac2d2cb379c072c6b",
"assets/assets/images/player/run/Run%2520(8).png": "dcf1813f831bec558a92a00ebd0b913b",
"assets/assets/images/player/run/Run%2520(4).png": "a6e5dc9b61566ed28c99399b0bf66f3f",
"assets/assets/images/player/run/Run%2520(5).png": "c8cc0a8d09d0c8e356905a53b28dcfd2",
"assets/assets/images/player/run/Run%2520(2).png": "6bb12d487dec533e33b85c43add40a47",
"assets/assets/images/player/run/Run%2520(3).png": "ed9a079b241eb25da76516e0cbb3d6d6",
"assets/assets/audio/music.mp3": "67d3e32072585a924ccb978e34c349a8"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
