import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/invoice_service.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class InvoiceDownloadWidget extends StatefulWidget {
  final TripDetails tripDetails;

  const InvoiceDownloadWidget({
    super.key,
    required this.tripDetails,
  });

  @override
  State<InvoiceDownloadWidget> createState() => _InvoiceDownloadWidgetState();
}

class _InvoiceDownloadWidgetState extends State<InvoiceDownloadWidget> {
  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'invoice'.tr,
                style: textBold.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(
            'download_or_share_invoice'.tr,
            style: textSmall.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: isGenerating
                      ? null
                      : () async {
                          setState(() {
                            isGenerating = true;
                          });

                          try {
                            final invoiceFile =
                                await InvoiceService.generateInvoicePdf(
                              tripDetails: widget.tripDetails,
                            );

                            await InvoiceService.downloadInvoice(invoiceFile);
                            showCustomSnackBar(
                              'invoice_downloaded'.tr,
                              isError: false,
                            );
                          } catch (e) {
                            showCustomSnackBar('error_generating_invoice'.tr);
                          }

                          setState(() {
                            isGenerating = false;
                          });
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isGenerating)
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.download,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          'download'.tr,
                          style: textBold.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: InkWell(
                  onTap: isGenerating
                      ? null
                      : () async {
                          setState(() {
                            isGenerating = true;
                          });

                          try {
                            final invoiceFile =
                                await InvoiceService.generateInvoicePdf(
                              tripDetails: widget.tripDetails,
                            );

                            await InvoiceService.shareInvoice(invoiceFile);
                          } catch (e) {
                            showCustomSnackBar('error_generating_invoice'.tr);
                          }

                          setState(() {
                            isGenerating = false;
                          });
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isGenerating)
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        else
                          const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 16,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          'share'.tr,
                          style: textBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
