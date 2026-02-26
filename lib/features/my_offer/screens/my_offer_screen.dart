import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/widget/offer_coupon_card_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/home/controllers/category_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/discount_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/discount_cart_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/no_coupon_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class MyOfferScreen extends StatefulWidget {
  final bool fromDashboard;
  final bool isCoupon;
  const MyOfferScreen({super.key, this.isCoupon = false, this.fromDashboard = false});

  @override
  State<MyOfferScreen> createState() => _MyOfferScreenState();
}

class _MyOfferScreenState extends State<MyOfferScreen> {
  final ScrollController scrollController = ScrollController();
  final OfferController offerController = Get.find<OfferController>();

  @override
  void initState() {
    if(widget.isCoupon){
      offerController.setIsCouponSelected(true, isUpdate: false);
    }else{
      offerController.setIsCouponSelected(false, isUpdate: false);
    }

    if(offerController.bestOfferModel == null){
      offerController.getOfferList(1);
    }
    Get.find<CategoryController>().setCouponFilterIndex(0,isUpdate: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (res,val){
          _onPopScopePress(res);
        },
        child: Scaffold(body: BodyWidget(
          appBar: AppBarWidget(
            title: 'my_offer'.tr, showBackButton: true, fromMyOfferScreen: true,
            onBackPressed: (){
              _onBackPress();
            },
          ),
          body: GetBuilder<OfferController>(builder: (offerController){
            return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Stack(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(offerController.isCouponSelected)...[
                    Text('available_coupon'.tr, style: textSemiBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    _CategoryList()
                  ],

                  Expanded(child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(children: [
                      !offerController.isCouponSelected ?
                      GetBuilder<OfferController>(builder: (offerController){
                        return (offerController.bestOfferModel!.data!= null && offerController.bestOfferModel!.data!.isNotEmpty) ?
                        PaginatedListWidget(
                          scrollController: scrollController,
                          onPaginate: (int? offset) async {
                            await offerController.getOfferList(offset!);
                          },
                          totalSize: offerController.bestOfferModel?.totalSize,
                          offset: int.parse(offerController.bestOfferModel!.offset.toString()),
                          itemView: ListView.separated(
                            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                            itemCount: offerController.bestOfferModel!.data!.length,
                            itemBuilder: (context, index){
                              return InkWell(
                                onTap: (){
                                  Get.to(()=>  DiscountScreen(offerModel: offerController.bestOfferModel!.data![index]));
                                },

                                child: DiscountCartWidget(offerModel: offerController.bestOfferModel!.data![index]),
                              );
                            },
                            separatorBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSeven),
                                child: Divider(color: Theme.of(context).hintColor.withValues(alpha:0.25)),
                              );
                            },
                          ),
                        ) :
                        NoCouponWidget(
                          title: 'no_discount_found'.tr,
                          description: 'sorry_there_is_no_discount'.tr,
                        );
                      }) :

                      GetBuilder<CouponController>(builder: (couponController){
                        return (couponController.couponModel!.data != null && couponController.couponModel!.data!.isNotEmpty) ?
                          PaginatedListWidget(
                            scrollController: scrollController,
                            onPaginate: (int? offset) async {
                              await couponController.getCouponList(offset!);
                            },
                            totalSize: couponController.couponModel?.totalSize,
                            offset: int.parse(couponController.couponModel!.offset.toString()),
                            itemView:  ListView.separated(shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              itemCount: couponController.couponModel!.data!.length,
                              itemBuilder: (context, index){
                                return OfferCouponCardWidget(
                                  fromCouponScree: true,
                                  coupon: couponController.couponModel!.data![index],
                                  index: index,
                                );
                              },
                              separatorBuilder: (context, index){
                                return const SizedBox(height: Dimensions.paddingSizeDefault);
                              },
                            ),
                          ) :
                          NoCouponWidget(
                            title: 'no_coupon_available'.tr,
                            description: 'sorry_there_is_no_coupon'.tr,
                          );
                      })
                    ]),
                  ))
                ]),

                if(!offerController.isCouponSelected)
                Align(alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: ()=> Get.bottomSheet(
                      SizedBox(width: Get.width,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: 30),

                          Text('we_do_the_best_for_you'.tr,style: textSemiBold),

                          Divider(color: Theme.of(context).hintColor.withValues(alpha:0.15)),

                          Text(
                            'if_you_have_multiple_eligible_discounts_we_will_automatically_apply_the_discount_that_will_save_you_the_most_to_your_next_trip'.tr,
                            style: textRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 50)
                        ]),
                      ) ,
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    child: Icon(Icons.info,color: Theme.of(context).primaryColor),
                  ),
                )
              ])
            );
          }),
        )),
      ),
    );
  }

  void _onPopScopePress(bool res){
    if(widget.fromDashboard){
      Get.back();
    }else{
      if(offerController.isCouponSelected){
        offerController.setIsCouponSelected(false);
      }else{
        if(!res){
          if(Navigator.canPop(context)){
            Get.back();
          }else{
            Get.offAll(()=> const DashboardScreen());
          }
        }
      }
    }
  }

  void _onBackPress(){
    if(widget.fromDashboard){
      Get.back();
    }else{
      if(offerController.isCouponSelected){
        offerController.setIsCouponSelected(false);
      }else{
        if(Navigator.canPop(context)){
          Get.back();
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
      }
    }

  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController){
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 30),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: (categoryController.categoryList?.length ?? 0) + 2,
          itemBuilder: (context, index){
            return InkWell(
              onTap: ()=> categoryController.setCouponFilterIndex(index),
              child: Container(
                decoration: BoxDecoration(
                    color:
                    categoryController.couponFilterIndex == index ?
                    Theme.of(context).primaryColor :
                    Theme.of(context).hintColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: Center(child: Text(
                  index == 0 ? 'all'.tr :
                  index == 1 ?
                  'parcel'.tr :
                  categoryController.categoryList?[index - 2].name ?? '',
                  style: textRegular.copyWith(color: categoryController.couponFilterIndex == index ? Theme.of(context).cardColor : null),
                )),
              ),
            );
          },
          separatorBuilder: (ctx, index){
            return const SizedBox(width: Dimensions.paddingSizeSmall);
          },
        ),
      );
    });
  }
}

