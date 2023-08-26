import 'package:multi_vender_store_app/extensions/enum.dart';

extension DiscountExtension on DiscountType {
  static const Map<String, DiscountType> _stringToDiscount = {
    'percentage': DiscountType.percentage,
    'rs': DiscountType.rs,
  };

  String get stringValue {
    return toString().split('.').last;
  }

  static DiscountType fromString(String value) {
    return _stringToDiscount[value] ?? DiscountType.percentage;
  }
  
  static String fromEnum(DiscountType value) {
    // print(value.stringValue);
    return value.stringValue;
  }
}