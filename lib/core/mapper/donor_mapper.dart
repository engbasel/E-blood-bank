import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';

class DonorMapper {
  static DonorModel toModel(DonorRequestEntity entity) {
    return DonorModel(
      name: entity.name,
      age: entity.age,
      bloodType: entity.bloodType,
      donationType: entity.donationType,
      idCard: entity.idCard,
      lastDonationDate: entity.lastDonationDate,
      nextDonationDate: entity.nextDonationDate,
      lastRequestDate: entity.lastRequestDate,
      medicalConditions: entity.medicalConditions,
      contact: entity.contact,
      address: entity.address,
      notes: entity.notes,
      units: entity.units,
      gender: entity.gender,
      uId: entity.uId,
      hospitalName: entity.hospitalName,
      distance: entity.distance,
      photoUrl: entity.photoUrl ?? '',
    );
  }


  static DonorRequestEntity toEntity(DonorModel model) {
    return DonorRequestEntity(
      name: model.name,
      uId: model.uId,
      age: model.age,
      bloodType: model.bloodType,
      donationType: model.donationType,
      idCard: model.idCard,
      lastDonationDate: model.lastDonationDate,
      nextDonationDate: model.nextDonationDate,
      lastRequestDate: model.lastRequestDate,
      medicalConditions: model.medicalConditions,
      contact: model.contact,
      address: model.address,
      notes: model.notes,
      units: model.units,
      gender: model.gender,
      hospitalName: model.hospitalName,
      distance: model.distance,
      photoUrl: model.photoUrl,
    );
  }
}
