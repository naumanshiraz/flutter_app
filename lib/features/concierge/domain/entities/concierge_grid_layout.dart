enum ConciergeGridLayout { horizontal, vertical, verticalRight, grid }

ConciergeGridLayout conciergeGridLayoutFromApiValue(String? value) {
  switch (value) {
    case 'horizontal':
      return ConciergeGridLayout.horizontal;
    case 'vertical':
      return ConciergeGridLayout.vertical;
    case 'verticalRight':
      return ConciergeGridLayout.verticalRight;
    case 'grid':
    default:
      return ConciergeGridLayout.grid;
  }
}
