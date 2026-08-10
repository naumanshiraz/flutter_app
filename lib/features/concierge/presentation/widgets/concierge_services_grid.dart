import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_grid_layout.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_item.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/service_card.dart';

class ConciergeServicesGrid extends StatelessWidget {
  final List<ConciergeServiceItem> items;
  final ConciergeGridLayout layout;
  final void Function(ServiceListing service)? onServiceTap;
  final void Function(ServiceListing service)? onServiceMorePressed;

  const ConciergeServicesGrid({
    super.key,
    required this.items,
    this.layout = ConciergeGridLayout.grid,
    this.onServiceTap,
    this.onServiceMorePressed,
  });

  static const double _bannerAspectRatio = 2.4;
  static const double _tallAspectRatio = 0.62;
  static const double _normalAspectRatio = 1.3;
  static const double _captionBlockHeight = 52;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    switch (layout) {
      case ConciergeGridLayout.horizontal:
        return _buildHorizontalFirst(items);
      case ConciergeGridLayout.vertical:
        return _buildVerticalFirst(items, tallOnRight: false);
      case ConciergeGridLayout.verticalRight:
        return _buildVerticalFirst(items, tallOnRight: true);
      case ConciergeGridLayout.grid:
        return _buildMixedGrid(items);
    }
  }

  /// items[0] full-width banner, rest in the mixed banner/grid section.
  Widget _buildHorizontalFirst(List<ConciergeServiceItem> items) {
    final rest = items.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(items.first.service, aspectRatio: _bannerAspectRatio),
        if (rest.isNotEmpty) SizedBox(height: 16.h),
        _buildMixedGrid(rest),
      ],
    );
  }

  Widget _buildVerticalFirst(List<ConciergeServiceItem> items, {required bool tallOnRight}) {
    final tall = items.first.service;
    final stack = items.skip(1).take(2).toList();
    final rest = items.skip(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stack.isEmpty)
          _card(tall, aspectRatio: _tallAspectRatio)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columnWidth = (constraints.maxWidth - 12.w) / 2;
              final stackedImageHeight = columnWidth / _normalAspectRatio;
              final stackedColumnHeight = stack.length * (stackedImageHeight + _captionBlockHeight.h) +
                  (stack.length - 1) * 16.h;
              final tallImageHeight = stackedColumnHeight - _captionBlockHeight.h;

              final tallColumn = Expanded(child: _card(tall, imageHeight: tallImageHeight));
              final stackedColumn = Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < stack.length; i++) ...[
                      _card(stack[i].service, imageHeight: stackedImageHeight),
                      if (i != stack.length - 1) SizedBox(height: 16.h),
                    ],
                  ],
                ),
              );

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tallOnRight
                    ? [stackedColumn, SizedBox(width: 12.w), tallColumn]
                    : [tallColumn, SizedBox(width: 12.w), stackedColumn],
              );
            },
          ),
        if (rest.isNotEmpty) SizedBox(height: 16.h),
        _buildMixedGrid(rest),
      ],
    );
  }

  Widget _buildMixedGrid(List<ConciergeServiceItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    int i = 0;
    while (i < items.length) {
      if (items[i].isBanner) {
        rows.add(_card(items[i].service, aspectRatio: _bannerAspectRatio));
        i++;
      } else {
        final hasPair = i + 1 < items.length && !items[i + 1].isBanner;
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _card(items[i].service, aspectRatio: _normalAspectRatio)),
              SizedBox(width: 12.w),
              Expanded(
                child: hasPair ? _card(items[i + 1].service, aspectRatio: _normalAspectRatio) : const SizedBox(),
              ),
            ],
          ),
        );
        i += hasPair ? 2 : 1;
      }
      if (i < items.length) rows.add(SizedBox(height: 16.h));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _card(ServiceListing service, {double? aspectRatio, double? imageHeight}) {
    return ServiceCard(
      service: service,
      imageAspectRatio: imageHeight == null ? (aspectRatio ?? _normalAspectRatio) : null,
      imageHeight: imageHeight,
      onTap: onServiceTap == null ? null : () => onServiceTap!(service),
      onMorePressed: onServiceMorePressed == null ? null : () => onServiceMorePressed!(service),
    );
  }
}
