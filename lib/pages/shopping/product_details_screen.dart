import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/product.dart';

class ProductViewScreen extends StatelessWidget {
  final Product pm;
  const ProductViewScreen(this.pm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageIndex = 0.obs;
    return Scaffold(
      appBar: AppBar(title: const Text("Produt view")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 5),
                CarouselSlider.builder(
                  options: CarouselOptions(
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      // aspectRatio: 16 / 21,
                      height: 300.0,
                      viewportFraction: 0.7,
                      enableInfiniteScroll: false,
                      // autoPlay: true,
                      // enlargeCenterPage: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      // padEnds: false,
                      // clipBehavior: Clip.antiAlias,
                      onPageChanged: (index, reason) {
                        imageIndex.value = index;
                      }),
                  itemCount: pm.list_images.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    // color: Colors.orange.shade100,
                    child: CachedNetworkImage(
                        imageUrl: pm.list_images[itemIndex].url),
                  ),
                ),
                const SizedBox(height: 5),
                Obx(() => DotsIndicator(
                      dotsCount: pm.list_images.length,
                      position: imageIndex.value.toDouble(),
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(15.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(pm.name, softWrap: true),
                ),
                Container(
                  color: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Price  ",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${pm.list_prices.first.mrp}  ",
                          textScaleFactor: 1.5,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "\u{20B9}${pm.list_prices.first.price}",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                if (pm.descriptions != null)
                  Column(
                    children: pm.descriptions
                        .map((e) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(MdiIcons.circleSmall),
                                Expanded(
                                    child: Text(e.toString(), softWrap: true)),
                                const SizedBox(height: 5),
                              ],
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Card(
                    color: Colors.red,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Buy now",
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white)),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
