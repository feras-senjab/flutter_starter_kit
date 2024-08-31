class Pagination {
  final int pageSize;
  final int currentPage;

  Pagination({
    required this.pageSize,
    this.currentPage = 1,
  });

  Pagination nextPage() =>
      Pagination(pageSize: pageSize, currentPage: currentPage + 1);

  Pagination previousPage() => Pagination(
      pageSize: pageSize, currentPage: (currentPage > 1) ? currentPage - 1 : 1);

  /// Calculate the starting point for pagination
  int calculateStartAfter() {
    return pageSize * (currentPage - 1);
  }

  @override
  String toString() => 'Page: $currentPage, Size: $pageSize';
}
