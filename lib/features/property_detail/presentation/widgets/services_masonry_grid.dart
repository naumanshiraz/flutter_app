import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/service_card.dart';

class ServicesMasonryGrid extends StatelessWidget {
  final List<ServiceListing> services;
  final ServicesGridLayout layout;
  final void Function(ServiceListing service)? onServiceTap;
  final void Function(ServiceListing service)? onServiceMorePressed;

  const ServicesMasonryGrid({
    super.key,
    required this.services,
    this.layout = ServicesGridLayout.grid,
    this.onServiceTap,
    this.onServiceMorePressed,
  });

  static const double _bannerAspectRatio = 2.4; // short, wide banner
  static const double _tallAspectRatio = 0.62; // tall left tile
  static const double _normalAspectRatio = 1.3; // plain grid tile

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    switch (layout) {
      case ServicesGridLayout.horizontal:
        return _buildHorizontalFirst(services);
      case ServicesGridLayout.vertical:
        return _buildVerticalFirst(services);
      case ServicesGridLayout.grid:
        return _buildPlainGrid(services);
    }
  }

  /// View 01: services[0] full-width, rest in a plain 2-column grid.
  Widget _buildHorizontalFirst(List<ServiceListing> services) {
    final rest = services.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(services.first, aspectRatio: _bannerAspectRatio),
        if (rest.isNotEmpty) SizedBox(height: 16.h),
        _buildPlainGrid(rest),
      ],
    );
  }

  // Caption block (name + up to 2 lines of description + spacing) is
  // capped to a fixed height so the height math below is exact rather
  // than guessed — matches the `maxLines: 1` / `maxLines: 2` caps on
  // the name/description Text widgets in ServiceCard.
  static const double _captionBlockHeight = 52;

  /// View 02: services[0] tall on the left, sized to exactly match the
  /// combined height of services[1] and services[2] stacked on the
  /// right. Computed explicitly from the available width (not
  /// `IntrinsicHeight` + `Expanded`, which collapses once a network
  /// image is involved — see the note on `ServiceCard.imageHeight`);
  /// anything beyond the first 3 falls back to a plain 2-column grid.
  Widget _buildVerticalFirst(List<ServiceListing> services) {
    final tall = services.first;
    final rightStack = services.skip(1).take(2).toList();
    final rest = services.skip(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rightStack.isEmpty)
          _card(tall, aspectRatio: _tallAspectRatio)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columnWidth = (constraints.maxWidth - 12.w) / 2;
              final rightImageHeight = columnWidth / _normalAspectRatio;
              final rightColumnHeight = rightStack.length * (rightImageHeight + _captionBlockHeight.h) +
                  (rightStack.length - 1) * 16.h;
              final tallImageHeight = rightColumnHeight - _captionBlockHeight.h;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _card(tall, imageHeight: tallImageHeight)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < rightStack.length; i++) ...[
                          _card(rightStack[i], imageHeight: rightImageHeight),
                          if (i != rightStack.length - 1) SizedBox(height: 16.h),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        if (rest.isNotEmpty) SizedBox(height: 16.h),
        _buildPlainGrid(rest),
      ],
    );
  }

  /// View 03 (and the "everything else" tail of the other two views):
  /// a plain 2-column grid, pairing items two at a time. A trailing odd
  /// item gets a half-width slot rather than stretching full width, so
  /// it doesn't look like a mistaken banner tile.
  Widget _buildPlainGrid(List<ServiceListing> services) {
    if (services.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (int i = 0; i < services.length; i += 2) {
      final hasPair = i + 1 < services.length;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _card(services[i], aspectRatio: _normalAspectRatio)),
            SizedBox(width: 12.w),
            Expanded(child: hasPair ? _card(services[i + 1], aspectRatio: _normalAspectRatio) : const SizedBox()),
          ],
        ),
      );
      if (i + 2 < services.length) rows.add(SizedBox(height: 16.h));
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
