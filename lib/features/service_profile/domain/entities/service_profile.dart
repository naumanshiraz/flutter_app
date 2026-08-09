import 'package:equatable/equatable.dart';

class ServiceReply extends Equatable {
  final String authorInitial;
  final String authorName;
  final String text;

  const ServiceReply({
    required this.authorInitial,
    required this.authorName,
    required this.text,
  });

  @override
  List<Object?> get props => [
        authorInitial,
        authorName,
        text,
      ];
}

class ServiceComment extends Equatable {
  final String id;
  final String authorInitial;
  final String authorName;
  final String text;
  final List<ServiceReply> replies;

  const ServiceComment({
    required this.id,
    required this.authorInitial, 
    required this.authorName, 
    required this.text,
    this.replies = const [],
  });

  @override
  List<Object?> get props => [
    id,
    authorInitial, 
    authorName, 
    text,
    replies,
  ];
}

class ServiceProfile extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String heroImageUrl;
  final String tagline;
  final String description;
  final double rating;
  final List<ServiceComment> comments;

  const ServiceProfile({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.heroImageUrl,
    required this.tagline,
    required this.description,
    required this.rating,
    required this.comments,
  });

  @override
  List<Object?> get props => [
    id, 
    name, 
    subtitle, 
    heroImageUrl, 
    tagline, 
    description, 
    rating, 
    comments,
  ];
}
