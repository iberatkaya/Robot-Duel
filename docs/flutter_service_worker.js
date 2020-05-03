'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "2b0d1e92c964491e3c5bab8736c31267",
"/": "2b0d1e92c964491e3c5bab8736c31267",
"main.dart.js": "e459cd16c865f24df296af7bb90a8324",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "bd6d9574c9753f2b3012d14f5ee441fb",
"assets/LICENSE": "71e276be7dd4ed8a9289f66d4ce285f4",
"assets/AssetManifest.json": "41d8c0417e956c2a9af6c7a2a8ad0094",
"assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/images/beam.png": "041cf2fb7237a376fc557438aca02665",
"assets/assets/images/background%2520(1).png": "5cf9845788e583ce310075c412e7dc7d",
"assets/assets/images/enemy/dead/Dead%2520(5).png": "d46233a3d15fcaa0a893766eb91b4c3c",
"assets/assets/images/enemy/dead/Dead%2520(9).png": "1987f2be218a6a1c0f9f1c1d0166f4d2",
"assets/assets/images/enemy/dead/Dead%2520(2)%2520Flip.png": "e614201b9d4d3a9e958722966167f29f",
"assets/assets/images/enemy/dead/Dead%2520(7)%2520Flip.png": "eb58d180f23b53547c22a3b55e546eda",
"assets/assets/images/enemy/dead/Dead%2520(8).png": "91ca429529d00650e6d67900c5b0fd62",
"assets/assets/images/enemy/dead/Dead%2520(4).png": "e3344aa46c926a9b1e9341cf103bf38d",
"assets/assets/images/enemy/dead/Dead%2520(10)%2520Flip.png": "61bb9929584fdc47ea923703ad0fc0df",
"assets/assets/images/enemy/dead/Dead%2520(3).png": "aefa7bb4a9b27589dfd58ae768ec1e0b",
"assets/assets/images/enemy/dead/Dead%2520(4)%2520Flip.png": "40b98e3a839ea4ab579fa7934fea04ef",
"assets/assets/images/enemy/dead/Dead%2520(1)%2520Flip.png": "452732e8666835bebab52e194d24b2c8",
"assets/assets/images/enemy/dead/Dead%2520(2).png": "0a6aa5756331f616f63ce86853e26f7c",
"assets/assets/images/enemy/dead/Dead%2520(8)%2520Flip.png": "0961cba63e437ea709604830b88bda73",
"assets/assets/images/enemy/dead/Dead%2520(6)%2520Flip.png": "7cee74f255312aed46548a6bd9fb6a6d",
"assets/assets/images/enemy/dead/Dead%2520(1).png": "2fd273cf881ea6eb9fc06846b40966bc",
"assets/assets/images/enemy/dead/Dead%2520(10).png": "1987f2be218a6a1c0f9f1c1d0166f4d2",
"assets/assets/images/enemy/dead/Dead%2520(3)%2520Flip.png": "948459a782c64b99cca0e5466e130e4a",
"assets/assets/images/enemy/dead/Dead%2520(9)%2520Flip.png": "61bb9929584fdc47ea923703ad0fc0df",
"assets/assets/images/enemy/dead/Dead%2520(7).png": "aba08bdbedc7606fdcbf41c0ca4dfbe0",
"assets/assets/images/enemy/dead/Dead%2520(5)%2520Flip.png": "f94d2f02063e0898f844e4de7e9efe06",
"assets/assets/images/enemy/dead/Dead%2520(6).png": "11d8f21d75b19e82a28d84a9c45f391b",
"assets/assets/images/enemy/idle/Idle%2520(2)%2520Flip.png": "f0ef1357ae410514a2455a7f9fda48ef",
"assets/assets/images/enemy/idle/Idle%2520(1).png": "e16a31afe4fb0a4ba1b105bd165a8a90",
"assets/assets/images/enemy/idle/Idle%2520(7)%2520Flip.png": "5e6a9198f04f9b0a03481ba03ede298b",
"assets/assets/images/enemy/idle/Idle%2520(4)%2520Flip.png": "bd7d8bac0693d37ec7d62f9c91eb4db9",
"assets/assets/images/enemy/idle/Idle%2520(7).png": "8d6a2beb5c30e8dae95a0ae117e2b42c",
"assets/assets/images/enemy/idle/Idle%2520(6).png": "95947caddc1a10a3525a02af19672317",
"assets/assets/images/enemy/idle/Idle%2520(8)%2520Flip.png": "bbc538f83ac2f85358fe439d46699e83",
"assets/assets/images/enemy/idle/Idle%2520(1)%2520Flip.png": "463eb6f1ee05a362ec3daa6f17e004c3",
"assets/assets/images/enemy/idle/Idle%2520(9).png": "a6fbfd88d493abe655ca89abd1367b12",
"assets/assets/images/enemy/idle/Idle%2520(6)%2520Flip.png": "555141dec92c7b83e7bf9d1c1912097b",
"assets/assets/images/enemy/idle/Idle%2520(5).png": "906fecb01c8f5699809f3084013f6d78",
"assets/assets/images/enemy/idle/Idle%2520(4).png": "5b44d9c8799bc1adb7a8270fa40d549f",
"assets/assets/images/enemy/idle/Idle%2520(3)%2520Flip.png": "7e020ddda4ee3dd8dcbf1dfbd0ac4670",
"assets/assets/images/enemy/idle/Idle%2520(8).png": "8ec101d96fe61a77d41f1e5ee6e829c1",
"assets/assets/images/enemy/idle/Idle%2520(3).png": "27a6278136befaf6da54a40f342c9ba0",
"assets/assets/images/enemy/idle/Idle%2520(10)%2520Flip.png": "659adf441b02a368fbc3d23e4eb543fc",
"assets/assets/images/enemy/idle/Idle%2520(9)%2520Flip.png": "b836d80092b4df1f318e48c176563124",
"assets/assets/images/enemy/idle/Idle%2520(5)%2520Flip.png": "c916c8035224ba61e69883f28195a62e",
"assets/assets/images/enemy/idle/Idle%2520(10).png": "633a2193c53c4020e5aa53da59230618",
"assets/assets/images/enemy/idle/Idle%2520(2).png": "4d6f8c95485c77cd5f6257033b00b0ff",
"assets/assets/images/enemy/run/Run%2520(2)%2520Flip.png": "da6259f36f8b7c80016120d6a1103321",
"assets/assets/images/enemy/run/Run%2520(7)%2520Flip.png": "9867c301ea7045c5db29090c6d9f791c",
"assets/assets/images/enemy/run/Run%2520(1).png": "9c8813d25547b9606ca006ca481d58b6",
"assets/assets/images/enemy/run/Run%2520(4)%2520Flip.png": "a47f597eae7d3f396dc69f08d9155af2",
"assets/assets/images/enemy/run/Run%2520(6).png": "a7b3822a513a44a94a6808d24a3c73b0",
"assets/assets/images/enemy/run/Run%2520(8)%2520Flip.png": "f456a8536352a80f6d016d9125168ba4",
"assets/assets/images/enemy/run/Run%2520(7).png": "58798f21a3a3b359f55260af2b4f69c9",
"assets/assets/images/enemy/run/Run%2520(1)%2520Flip.png": "11daebaeb2d0f3ae59d232fb8285216a",
"assets/assets/images/enemy/run/Run%2520(6)%2520Flip.png": "cfbe3eb92ff7288a4b643f29038c3bcf",
"assets/assets/images/enemy/run/Run%2520(8).png": "fd5fafd93e01882e1a86e1bb03d3e762",
"assets/assets/images/enemy/run/Run%2520(4).png": "6f705adfce213fc5648fcc6927d36ee3",
"assets/assets/images/enemy/run/Run%2520(5).png": "1e4554831a3b4683bf54f353b45555e9",
"assets/assets/images/enemy/run/Run%2520(3)%2520Flip.png": "b764ec975a9d12e367d6c1faaf860d37",
"assets/assets/images/enemy/run/Run%2520(2).png": "88331c9c265b11d449ca3bc80f83eab7",
"assets/assets/images/enemy/run/Run%2520(3).png": "3367ccd3f60813ac1aca2c885ec5b948",
"assets/assets/images/enemy/run/Run%2520(5)%2520Flip.png": "ea76ffa7b48bd16a506357af94570099",
"assets/assets/images/enemy/shoot/Shoot%2520(2).png": "cbf5ebf056f6250bfcfdf3a0050ae2ff",
"assets/assets/images/enemy/shoot/Shoot%2520(3)%2520Flip.png": "202fb94d87442461cc41579f1e19be45",
"assets/assets/images/enemy/shoot/Shoot%2520(3).png": "eafad4bb2ed61108e8ccad5ffde4d003",
"assets/assets/images/enemy/shoot/Shoot%2520(4).png": "37f4cb8da29b1325253e6cb507b1049d",
"assets/assets/images/enemy/shoot/Shoot%2520(2)%2520Flip.png": "78b75c055d0d2d22205fb15a5f776dc7",
"assets/assets/images/enemy/shoot/Shoot%2520(4)%2520Flip.png": "e71f742497766b413c824e2e22c98436",
"assets/assets/images/enemy/shoot/Shoot%2520(1)%2520Flip.png": "6a0a9093790e766dcba41ac3534d6519",
"assets/assets/images/enemy/shoot/Shoot%2520(1).png": "341a627bd27782c0b8bb2f0e1f843380",
"assets/assets/images/background%2520(2).png": "e26b6fd7ca7d530e73b5a5a7b877d0ba",
"assets/assets/images/beamred.png": "b9cce0201e37c2636074df7c5daeab2a",
"assets/assets/images/player/dead/Dead%2520(5).png": "85fd474d7ef84fc34a0cccb57b32d75f",
"assets/assets/images/player/dead/Dead%2520(9).png": "0c79ab487db6a3ec737f113b61a6203e",
"assets/assets/images/player/dead/Dead%2520(2)%2520Flip.png": "6806d6ce2111e84674edde908f4951bf",
"assets/assets/images/player/dead/Dead%2520(7)%2520Flip.png": "33c6e56a949565ba72a6cedc33d6ee23",
"assets/assets/images/player/dead/Dead%2520(8).png": "b0c8225c000ff5cde90d03fb9991e57a",
"assets/assets/images/player/dead/Dead%2520(4).png": "f0efa7f2ad4d821e43494d37f9bfc07f",
"assets/assets/images/player/dead/Dead%2520(10)%2520Flip.png": "28900820a2bab06175c069d4e47ba400",
"assets/assets/images/player/dead/Dead%2520(3).png": "505262a19c79da550d5a5900e5732050",
"assets/assets/images/player/dead/Dead%2520(4)%2520Flip.png": "eee2b4e9cd33b8d2a569985acdbb2b17",
"assets/assets/images/player/dead/Dead%2520(1)%2520Flip.png": "97610f60f5232474ca396e7c413fab21",
"assets/assets/images/player/dead/Dead%2520(2).png": "36e8b71082ee990419e3ebad8d552bae",
"assets/assets/images/player/dead/Dead%2520(8)%2520Flip.png": "839d0b688e14c72aeae0a2c6be6b036d",
"assets/assets/images/player/dead/Dead%2520(6)%2520Flip.png": "a6580264afd1458aa679eca21f9d0c99",
"assets/assets/images/player/dead/Dead%2520(1).png": "ab4b437fffc70ffe9d45aac256762ede",
"assets/assets/images/player/dead/Dead%2520(10).png": "0c79ab487db6a3ec737f113b61a6203e",
"assets/assets/images/player/dead/Dead%2520(3)%2520Flip.png": "2adfb096060b794e87af151d998a2c03",
"assets/assets/images/player/dead/Dead%2520(9)%2520Flip.png": "28900820a2bab06175c069d4e47ba400",
"assets/assets/images/player/dead/Dead%2520(7).png": "4a0b1cf18a8664f7312105fa2efcb7ff",
"assets/assets/images/player/dead/Dead%2520(5)%2520Flip.png": "691af11a4acae4b647ae2634b34a0db3",
"assets/assets/images/player/dead/Dead%2520(6).png": "7c52e1ac08b3b9a0f3d92fbbb95faa1e",
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
