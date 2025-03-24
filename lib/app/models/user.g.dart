// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id_user'] as num).toInt(),
      login: json['login'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      creationDate: DateTime.parse(json['creation_date'] as String),
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id_user': instance.id,
      'login': instance.login,
      'email': instance.email,
      'bio': instance.bio,
      'creation_date': instance.creationDate.toIso8601String(),
      'photo_url': instance.photoUrl,
    };
