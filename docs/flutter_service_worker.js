'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "2b0d1e92c964491e3c5bab8736c31267",
"/": "2b0d1e92c964491e3c5bab8736c31267",
"main.dart.js": "b7a3c3eb44845ee40a476197e2f60009",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "bd6d9574c9753f2b3012d14f5ee441fb",
"assets/LICENSE": "4f8ffe5b550fc2742f681e9acdc8f925",
"assets/AssetManifest.json": "b19b3b81151b1fb1b8d7a2cc8b8fa688",
"assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/images/beam.png": "041cf2fb7237a376fc557438aca02665",
"assets/assets/images/background%2520(1).png": "5cf9845788e583ce310075c412e7dc7d",
"assets/assets/images/background%2520(2).png": "e26b6fd7ca7d530e73b5a5a7b877d0ba",
"assets/assets/images/player/idle/Idle%2520(2)%2520Flip.png": "061b1c01eab1fd221e4aa0e4f7732961",
"assets/assets/images/player/idle/Idle%2520(1).png": "637f97f026660a181bfbbee7fc3f5e8f",
"assets/assets/images/player/idle/Idle%2520(7)%2520Flip.png": "82f36fa8e4a54ed48ef084a69cd792b3",
"assets/assets/images/player/idle/Idle%2520(4)%2520Flip.png": "cd766e977909fd2f33215e37979b8ed0",
"assets/assets/images/player/idle/Idle%2520(7).png": "5bc8c368ad438d5e5764303ff7aca2e9",
"assets/assets/images/player/idle/Idle%2520(6).png": "b70ca9329fe1fb7d01e79be4fc917ab1",
"assets/assets/images/player/idle/Idle%2520(8)%2520Flip.png": "dba606bef79053a739faba285857aa93",
"assets/assets/images/player/idle/Idle%2520(1)%2520Flip.png": "57bdf6af24bc6bbb8625dee754c4ff41",
"assets/assets/images/player/idle/Idle%2520(9).png": "4dd5b6ca5b78a6ca5221bfc6f464adb5",
"assets/assets/images/player/idle/Idle%2520(6)%2520Flip.png": "14ad87ae42f2d249c8c9b626c934d70e",
"assets/assets/images/player/idle/Idle%2520(5).png": "d690f5dacdf3a95800cb36c3598bac04",
"assets/assets/images/player/idle/Idle%2520(4).png": "a141c632d9a1987b388ce4535dbbaf2a",
"assets/assets/images/player/idle/Idle%2520(3)%2520Flip.png": "69014e74560fb5989c02e5ce02b3396d",
"assets/assets/images/player/idle/Idle%2520(8).png": "8b093a3fae0031dd75c2849c132017d4",
"assets/assets/images/player/idle/Idle%2520(3).png": "821e1a08f829caa26b5d680908c9fbe1",
"assets/assets/images/player/idle/Idle%2520(10)%2520Flip.png": "32e03b194202e109a14f5d8eda030f86",
"assets/assets/images/player/idle/Idle%2520(9)%2520Flip.png": "8d3da0bb656136b6475a6b4f18fb7446",
"assets/assets/images/player/idle/Idle%2520(5)%2520Flip.png": "50d4469d1828eb5e6e9c87c674154671",
"assets/assets/images/player/idle/Idle%2520(10).png": "f50d5025ff967dddfca6ac5514dacfb6",
"assets/assets/images/player/idle/Idle%2520(2).png": "0da5f1f0cdc9e9bacdd8d6884870d71a",
"assets/assets/images/player/run/Run%2520(2)%2520Flip.png": "7700a42339ae9b0c63bb7644b54e6e1d",
"assets/assets/images/player/run/Run%2520(7)%2520Flip.png": "ddddd8ef0a825d78326f6bcaac19e399",
"assets/assets/images/player/run/Run%2520(1).png": "12b04c25f6727159cb057a63e2c9bd39",
"assets/assets/images/player/run/Run%2520(4)%2520Flip.png": "d79f288630eed069b6a500b4619a94b8",
"assets/assets/images/player/run/Run%2520(6).png": "c7d8af0f6f78d7b8cc14d0be9bdd3c3a",
"assets/assets/images/player/run/Run%2520(8)%2520Flip.png": "9fa7a7712bfc8cc90d86606bab2958bf",
"assets/assets/images/player/run/Run%2520(7).png": "60900773ac3b720ac2d2cb379c072c6b",
"assets/assets/images/player/run/Run%2520(1)%2520Flip.png": "48af3811898eefd64ec1c6dfbe65f4a7",
"assets/assets/images/player/run/Run%2520(6)%2520Flip.png": "75acb69c73fd95dae38d3bc1edc1a284",
"assets/assets/images/player/run/Run%2520(8).png": "dcf1813f831bec558a92a00ebd0b913b",
"assets/assets/images/player/run/Run%2520(4).png": "a6e5dc9b61566ed28c99399b0bf66f3f",
"assets/assets/images/player/run/Run%2520(5).png": "c8cc0a8d09d0c8e356905a53b28dcfd2",
"assets/assets/images/player/run/Run%2520(3)%2520Flip.png": "96a9bdd5418ff4157bfd2a492aa182cd",
"assets/assets/images/player/run/Run%2520(2).png": "6bb12d487dec533e33b85c43add40a47",
"assets/assets/images/player/run/Run%2520(3).png": "ed9a079b241eb25da76516e0cbb3d6d6",
"assets/assets/images/player/run/Run%2520(5)%2520Flip.png": "d5ce7499b34114ccd99c151da32eeb5f",
"assets/assets/images/player/shoot/Shoot%2520(2).png": "57d2ca92b125e77f898dd0b293b63ed3",
"assets/assets/images/player/shoot/Shoot%2520(3)%2520Flip.png": "8168561f593a81f0131c402ba8a5f23a",
"assets/assets/images/player/shoot/Shoot%2520(3).png": "9297815b2888475d0ecd2d32127adef2",
"assets/assets/images/player/shoot/Shoot%2520(4).png": "038f5b00f022a9cccdc8af380e765fc7",
"assets/assets/images/player/shoot/Shoot%2520(2)%2520Flip.png": "b67ad661b68947a29692e30a63bdfdf0",
"assets/assets/images/player/shoot/Shoot%2520(4)%2520Flip.png": "99868060ff4e68fc8a7622856f5e20c6",
"assets/assets/images/player/shoot/Shoot%2520(1)%2520Flip.png": "eb2b7b10b2d4ed69192e3dce1c8c62dd",
"assets/assets/images/player/shoot/Shoot%2520(1).png": "26e8878f617372342172b6946d5cd509",
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
