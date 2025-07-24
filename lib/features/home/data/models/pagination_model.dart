import 'package:shartflix/features/home/domain/entities/pagination_entity.dart';

class PaginationModel {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  const PaginationModel({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalCount: json['totalCount'] ?? 0,
      perPage: json['perPage'] ?? 0,
      maxPage: json['maxPage'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }

  PaginationEntity toEntity() {
    return PaginationEntity(
      totalCount: totalCount,
      perPage: perPage,
      maxPage: maxPage,
      currentPage: currentPage,
    );
  }
} 