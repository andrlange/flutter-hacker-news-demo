import 'package:freezed_annotation/freezed_annotation.dart';
part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
abstract class ItemModel with _$ItemModel {
  // Add this private constructor to allow implementing methods and getters

  const ItemModel._();

  // Default constructor with named parameters
  const factory ItemModel({
    int? id,
    bool? deleted,
    String? type,
    String? by,
    int? time,
    String? text,
    bool? dead,
    int? parent,
    int? poll,
    List<dynamic>? kids,
    String? url,
    int? score,
    String? title,
    List<dynamic>? parts,
    int? descendants,
    String? cachedAt,
  }) = _ItemModel;

  // FromJson factory constructor for deserialization
  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  // The toJson method is automatically generated!
  // You don't need to explicitly define it in your class

  String get hiveId => 'item_$id';

  // Getter to calculate age in seconds
  int get ageInSeconds {
    return cachedAt != null
        ? DateTime.now().difference(DateTime.parse(cachedAt!)).inSeconds
        : 0;
  }
}
