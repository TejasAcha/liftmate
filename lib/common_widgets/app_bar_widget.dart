import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/calender_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/drop_down_widget.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final Function()? onBackPressed;
  final bool centerTitle;
  final double? fontSize;
  final bool isHome;
  final String? subTitle;
  final bool showTripHistoryFilter;
  final bool fromMyOfferScreen;
  const AppBarWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle= false,
    this.showActionButton= true,
    this.isHome = false,
    this.showTripHistoryFilter = false,
    this.fontSize,
    this.fromMyOfferScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: isHome ? () {
            Address? currentAddress = Get.find<LocationController>().getUserAddress();
            if(currentAddress == null || currentAddress.longitude == null){
              Get.to(() => const AccessLocationScreen());
            }else{
              Get.find<LocationController>().updatePosition(
                  LatLng(currentAddress.latitude!, currentAddress.longitude!), false,LocationType.location,
              );
              Get.to(() => PickMapScreen(type: LocationType.accessLocation,address: currentAddress));
            }
            
          } : null,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                if(subTitle != null)
                Text(
                  subTitle ?? '',
                  style: textRegular.copyWith(
                    fontSize: fontSize ??
                        (isHome ?  Dimensions.fontSizeLarge : Dimensions.fontSizeLarge),
                    color:Get.isDarkMode ? Colors.white.withValues(alpha: 0.8) : Colors.white,
                  ), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                ),

                Row(mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.center, children: [
                    Text(
                      title.tr,
                      style: textRegular.copyWith(
                        fontSize: fontSize ??   Dimensions.fontSizeLarge , color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.9) : Colors.white,
                      ), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                    ),

                  if(showTripHistoryFilter)
                  GetBuilder<TripController>(builder: (tripController){
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: DropDownWidget<int>(
                          showText: false,
                          showLeftSide: false,
                          menuItemWidth: 120,
                          icon: Container(height: 30,width: 30,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.filter_list_sharp, color: Theme.of(context).primaryColor,size: 16),
                          ),
                          maxListHeight: 200,
                          items: tripController.filterList.map((item) => CustomDropdownMenuItem<int>(
                            value: tripController.filterList.indexOf(item),
                            child: Text(item.tr,
                              style: textRegular.copyWith(
                                color: Get.isDarkMode ?
                                Get.find<TripController>().filterIndex == Get.find<TripController>().filterList.indexOf(item) ?
                                Theme.of(context).primaryColor :
                                Colors.white :
                                Get.find<TripController>().filterIndex == Get.find<TripController>().filterList.indexOf(item) ?
                                Theme.of(context).primaryColor :
                                Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                            ),
                          )).toList(),
                          hintText: tripController.filterList[Get.find<TripController>().filterIndex].tr,
                          borderRadius: 5,
                          onChanged: (int selectedItem) {
                            if(selectedItem == tripController.filterList.length-1) {
                              showDialog(context: context,
                                builder: (_) => CalenderWidget(onChanged: (value) => Get.back()),
                              );
                            }else {
                              tripController.setFilterTypeName(selectedItem);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ]),

                fromMyOfferScreen ?
                _MyOfferTabButtonWidget() :
                const SizedBox.shrink(),

                isHome ?
                GetBuilder<LocationController>(builder: (locationController) {
                  return Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    child: Row(mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.center, children: [
                      Icon(Icons.place_outlined,color: Get.isDarkMode ? Colors.white.withValues(alpha:0.8) : Colors.white, size: 16),
                      const SizedBox(width: Dimensions.paddingSizeSeven),

                      Flexible(child: Text(
                        locationController.getUserAddress()?.address ?? '',
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: textRegular.copyWith(color:Get.isDarkMode ? Colors.white.withValues(alpha:0.8) : Colors.white,
                            fontSize: Dimensions.fontSizeExtraSmall),
                      )),
                    ]),
                  );
                }) :
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        centerTitle: centerTitle,
        excludeHeaderSemantics: true,
        titleSpacing: 0,
        leading: showBackButton ?
        IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Get.isDarkMode ? Colors.white.withValues(alpha:0.8) : Colors.white,
          onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.canPop(context) ? Get.back() : Get.offAll(()=> const DashboardScreen()),
        ) :
        SizedBox(),
        actions: [
          if(!showTripHistoryFilter)
          SizedBox(width: Get.width * 0.1)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 150);
}

class _MyOfferTabButtonWidget extends StatelessWidget {
  const _MyOfferTabButtonWidget();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferController>(builder: (offerController){
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.25)),
          borderRadius: const  BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
          color: Theme.of(context).cardColor
        ),
        margin: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            onTap: ()=> offerController.setIsCouponSelected(false),
            child: Container(
              decoration: BoxDecoration(
                color: offerController.isCouponSelected ? null : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                child: Text(
                  'discounts'.tr,
                  style: textBold.copyWith(color: offerController.isCouponSelected ?
                  Theme.of(context).textTheme.bodyMedium!.color?.withValues(alpha:0.65) :
                  Theme.of(context).colorScheme.errorContainer, fontSize: Dimensions.fontSizeSmall
                  ),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: ()=> offerController.setIsCouponSelected(true),
            child: Container(
              decoration: BoxDecoration(
                color: offerController.isCouponSelected ? Theme.of(context).primaryColor : null,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                child: Text(
                  'coupons'.tr,
                  style: textBold.copyWith(
                    color:offerController.isCouponSelected ?
                    Theme.of(context).colorScheme.errorContainer :
                    Theme.of(context).textTheme.bodyMedium!.color?.withValues(alpha:0.65), fontSize: Dimensions.fontSizeSmall
                  ),
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }
}
