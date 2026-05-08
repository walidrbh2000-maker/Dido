// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuideModelImpl _$$GuideModelImplFromJson(Map<String, dynamic> json) =>
    _$GuideModelImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      destinationId: (json['destinationId'] as num).toInt(),
      langues:
          (json['langues'] as List<dynamic>).map((e) => e as String).toList(),
      experienceAnnees: (json['experienceAnnees'] as num?)?.toInt() ?? 0,
      tarifJour: (json['tarifJour'] as num).toDouble(),
      description: json['description'] as String?,
      image: json['image'] as String?,
      disponible: json['disponible'] as bool? ?? true,
    );

Map<String, dynamic> _$$GuideModelImplToJson(_$GuideModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'destinationId': instance.destinationId,
      'langues': instance.langues,
      'experienceAnnees': instance.experienceAnnees,
      'tarifJour': instance.tarifJour,
      'description': instance.description,
      'image': instance.image,
      'disponible': instance.disponible,
    };
