import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountImage extends StatelessWidget {
  final String imageUrl;
  AccountImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 40,
      height: 40,
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              placeholder: (context, url) => accountIcon,
              errorWidget: (context, url, error) => accountIcon,
            )
          : accountIcon,
    );
  }

  Icon get accountIcon {
    return Icon(
      Icons.account_circle_outlined,
      color: Colors.white,
    );
  }
}
