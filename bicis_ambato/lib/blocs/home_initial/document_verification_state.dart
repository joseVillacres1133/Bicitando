import 'package:equatable/equatable.dart';

class DocumentIdentificationState extends Equatable {
  // final bool isApproved;
  // final bool isLocked;
  // final bool isDenied;

  final String stateDocument;

  const DocumentIdentificationState( {required this.stateDocument});

  @override
  List<Object?> get props => [stateDocument];


}