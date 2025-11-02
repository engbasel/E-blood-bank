import 'dart:developer';

import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/data/datasources/needer_remote_data_source.dart';
import 'package:blood_bank/feature/home/data/model/needer_model.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:dartz/dartz.dart';

class NeederRepoImpl implements NeederRepo {
  final NeederRemoteDataSource remoteDataSource;

  NeederRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, void>> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    try {
      // check for active request
      final hasActive =
          await remoteDataSource.hasActiveRequest(addNeederInputEntity.uId);
      if (hasActive) {
        return Left(ServerFailure('activeRequest'));
      }

      final model = NeederModel.fromEntity(addNeederInputEntity);
      await remoteDataSource.addNeederRequest(model);

      // Fetch user info to include in notification
      try {
        final userData =
            await remoteDataSource.getUserById(addNeederInputEntity.uId);
        final userName = userData?['displayName'] ?? 'Anonymous';
        final userEmail = userData?['email'] ?? 'No Email';
        final photoUrl = userData?['photoUrl'] ?? '';

        await NotificationService.instance.sendNotificationToAllUsers(
          title: 'New Blood Request',
          body: '${addNeederInputEntity.patientName} needs blood!',
          data: {
            'type': 'new_request',
            'request_id': addNeederInputEntity.uId,
            'user_name': userName,
            'user_email': userEmail,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      } catch (e) {
        log('Failed to send notification: $e');
      }

      return const Right(null);
    } catch (e) {
      log('NeederRepoImpl.addNeederRequest error: $e');
      return Left(
        ServerFailure('Failed to add Request'),
      );
    }
  }
}
