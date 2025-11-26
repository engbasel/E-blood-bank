import 'package:blood_bank/feature/home/data/model/needer_model.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';

class NeederMapper {
  static NeederModel toModel(NeederRequestEntity entity) {
    return NeederModel(
      patientName: entity.patientName,
      age: entity.age,
      bloodType: entity.bloodType,
      donationType: entity.donationType,
      idCard: entity.idCard,
      medicalConditions: entity.medicalConditions,
      contact: entity.contact,
      address: entity.address,
      gender: entity.gender,
      uId: entity.uId,
      hospitalName: entity.hospitalName,
      dateTime: entity.dateTime,
      status: entity.status,
    );
  }


  static NeederRequestEntity toEntity(NeederModel model) {
    return NeederRequestEntity(
      patientName: model.patientName,
      age: model.age,
      bloodType: model.bloodType,
      donationType: model.donationType,
      idCard: model.idCard,
      medicalConditions: model.medicalConditions,
      contact: model.contact,
      address: model.address,
      gender: model.gender,
      uId: model.uId,
      hospitalName: model.hospitalName,
      dateTime: model.dateTime,
      status: model.status,
    );
  }
}
