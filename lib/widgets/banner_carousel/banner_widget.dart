import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/widgets/banner_carousel/banner_model.dart';
import 'package:flutter/material.dart';

@immutable
class BannerWidget extends StatelessWidget {
  final BannerModel _bannerModel;

  /// The [borderRadius] of the container
  /// Default value 5
  final double borderRadius;

  /// The [_onTap] The Method when click on the Banner
  final VoidCallback _onTap;

  final double spaceBetween;

  BannerWidget({
    Key key,
    BannerModel bannerModel,
    this.borderRadius = 5,
    this.spaceBetween = 0,
    VoidCallback onTap,
  })  : _bannerModel = bannerModel,
        _onTap = onTap,
        super(key: key);

  Widget get _getImage {
    if (_bannerModel.imagePath.contains("https://") ||
        _bannerModel.imagePath.contains("http://")) {
      return CachedNetworkImage(
        imageUrl: _bannerModel.imagePath,
        fit: BoxFit.fitWidth,
      );
    }
    return LoadAssetImage(_bannerModel.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spaceBetween),
            child: _getImage,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius)),
            width: double.maxFinite,
            // child: SizedBox(),
          ),
        ));
  }
}
