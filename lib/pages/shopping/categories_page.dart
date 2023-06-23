import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopau/models/category_model.dart';
import 'package:myshopau/pages/a_widgets/firestore_listview_builder.dart';

import '../a_widgets/text_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextW('Categories')),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListViewBuilder(
                query:
                    ShopCategory.col_ref.orderBy(ShopCategory.upload_time_key),
                builder: (p0, ds) {
                  var cm = ShopCategory.fromDS(ds);
                  return GFListTile(
                    shadow: const BoxShadow(color: Colors.transparent),
                    avatar: GFAvatar(
                      backgroundImage: cm.image_url != null
                          ? CachedNetworkImageProvider(cm.image_url!)
                          : null,
                    ),
                    titleText: cm.name,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
