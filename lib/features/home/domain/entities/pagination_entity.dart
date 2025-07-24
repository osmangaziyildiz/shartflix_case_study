import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  const PaginationEntity({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [totalCount, perPage, maxPage, currentPage];
} 