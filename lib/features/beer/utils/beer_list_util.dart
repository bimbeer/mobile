import '../../profile/models/profile.dart';

class BeerListUtil {
  static String? getBeerNameByLink(String link) {
    return beerList.firstWhere((element) => element.link == link).name;
  }
}

const beerList = <Beer>[
  Beer(
      name: 'Piast',
      link:
          'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fpl_08498_piast_milioner_2023_500ml.png?alt=media&token=79ff9750-0b44-445d-936e-e3bcfbbc614c'),
  Beer(
    name: 'Harnaś',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2F08149-harnas-opakowania-generyczne-5-9-alk_bottle.png?alt=media&token=3d4fde9d-465d-4541-89de-545973c1ab47',
  ),
  Beer(
    name: 'Carlsberg',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fcb_nd_50cl_pilsner_wet_bottle_kv_17k_iso_premium_merged_rgb.png?alt=media&token=3e32670a-9ba3-4c7a-a436-0db3a43d963e',
  ),
  Beer(
    name: 'Okocim Jasne',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fokocim-jasne-2022-butelka-500-ml.png?alt=media&token=f7e0edbd-35ae-412b-bc41-3989f4baf6fc',
  ),
  Beer(
    name: 'Okocim Porter',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fokocim-porter-2022-butelka-500-ml.png?alt=media&token=ad09cc3e-00fc-4c98-b022-8743b19632e3',
  ),
  Beer(
    name: 'Okocim 0.0%',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fokocim-00-2022-butelka-500-ml.png?alt=media&token=ea88737f-d58d-4a46-aa8e-d786ff22aea7',
  ),
  Beer(
    name: 'Książ',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fbutelka_ksiaz_pop.png?alt=media&token=7dc207dd-f2e9-4a19-98f7-c4ec18dc0de2',
  ),
  Beer(
    name: 'Kasztelan Jasne',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fbutelka-jpkasztelan-150cm-z-kroplami.png?alt=media&token=f74e8eea-11b5-4f99-bf36-006de3b71a2d',
  ),
  Beer(
    name: 'Kasztelan Mocne',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fbutelka-mocnekasztelan-150cm-z-kroplami.png?alt=media&token=aeb87989-9eb7-4522-9478-7c584f1f1f69',
  ),
  Beer(
    name: 'Žatecký Černý',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fzatecky-cerny-3-8.png?alt=media&token=64bcc74e-c39e-4e70-a6e1-28dae56239d4',
  ),
  Beer(
    name: 'Žatecký Ležák',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fpl_zatecky-svetly-lezak.png?alt=media&token=752d7ad0-d0b8-4d86-8fe5-631e1651835b',
  ),
  Beer(
    name: 'Karmi',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2FeYr599i.png?alt=media&token=af893b75-45df-4533-9a20-7c03ba02cf6e',
  ),
  Beer(
    name: 'Sommersby Apple',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fpl_somersby-apple.png?alt=media&token=64397b3d-12c1-426f-9d71-221182b690ee',
  ),
  Beer(
    name: 'Garage Mojito',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fgarage_dragon-fruit_-ciemniejszy_400.png?alt=media&token=f90d1e02-f768-4d06-a4ff-b438287f14e4',
  ),
  Beer(
    name: 'Garage Kamikaze',
    link:
        'https://firebasestorage.googleapis.com/v0/b/bimbeer-af1dd.appspot.com/o/beers%2Fgarage_kamikaze_400ml_2021.png?alt=media&token=933486bc-6475-42f9-93e1-a2df2d5fc058',
  ),
];
