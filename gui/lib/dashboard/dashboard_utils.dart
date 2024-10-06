import 'package:form_builder_validators/form_builder_validators.dart';

const FORMKEY_STUDENTID = 'dashboardStudentId';

/// Validators for voter form that validates an student ID.
final studentIdValidator = FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.integer(radix: 10),
  FormBuilderValidators.maxWordsCount(1),
  FormBuilderValidators.maxLength(12),
  FormBuilderValidators.minLength(12),
]);
