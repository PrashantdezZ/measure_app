part of global;

class FirestoreService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('patients');
  final CollectionReference _assessmentsCollection =
      FirebaseFirestore.instance.collection('assessments');
  final CollectionReference _assessmentTypeCollection =
      FirebaseFirestore.instance.collection('assessment_type');
  final CollectionReference _questionnaireCollection =
      FirebaseFirestore.instance.collection('questionnaire');
  Stream<List<Patient>> getPatients() {
    return _patientsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Patient.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<AssessmentType>> getAssessmentType() {
    return _assessmentTypeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AssessmentType.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> addAssessment(
      Assessment assessment,
      String selectedPatientId,
      String questionOneValue,
      String questionTwoValue,
      String questionThreeValue,
      String questionFourValue) async {
         CodeGenerator codeGenerator = CodeGenerator();
  String uniqueCode = codeGenerator.generateUniqueCode();
    final Map<String, dynamic> data = {
      'applicable_measures': assessment.applicableMeasures,
      'cognitive_status': assessment.cognitiveStatus,
      'patient_id':
          FirebaseFirestore.instance.doc('/patients/$selectedPatientId'),
      'result': assessment.result,
      'icdo':uniqueCode,
      'test': {
        'question1': questionOneValue,
        'question2': questionTwoValue,
        'question3': questionThreeValue,
        'question4': questionFourValue,
      },
      'updated_at': Timestamp.now(),
    };
   
    try {
      await _assessmentsCollection.add(data);
      
    } catch (e) {
      
    }
  }

  Stream<List<Map<String, dynamic>>> getAssessmentsWithPatients(
      bool isRecent) async* {
    Query<Object?> query = _assessmentsCollection;
    if (isRecent) {
      query = _assessmentsCollection.orderBy('updated_at', descending: true);
    }

    await for (var snapshot in query.snapshots()) {
      List<Map<String, dynamic>> assessmentsWithPatients = [];

      for (var doc in snapshot.docs) {
        Assessment assessment =
            Assessment.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        if (assessment.patientId != null) {
          DocumentSnapshot patientSnapshot = await assessment.patientId!.get();
          Patient patient = Patient.fromMap(
              patientSnapshot.data() as Map<String, dynamic>,
              patientSnapshot.id);

          assessmentsWithPatients.add({
            'assessment': assessment,
            'patient': patient,
          });
        }
      }

      yield assessmentsWithPatients;
    }
  }

  Stream<List<Map<String, dynamic>>> getRecentAssessmentsWithPatients() async* {
    Query<Object?> query =
        _assessmentsCollection.orderBy('updatedAt', descending: true);

    await for (var snapshot in query.snapshots()) {
      List<Map<String, dynamic>> assessmentsWithPatients = [];

      for (var doc in snapshot.docs) {
        Assessment assessment =
            Assessment.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        if (assessment.patientId != null) {
          DocumentSnapshot patientSnapshot = await assessment.patientId!.get();
          Patient patient = Patient.fromMap(
              patientSnapshot.data() as Map<String, dynamic>,
              patientSnapshot.id);

          assessmentsWithPatients.add({
            'assessment': assessment,
            'patient': patient,
          });
        }
      }

      yield assessmentsWithPatients;
    }
  }

  Future<Questionnaire?> getQuestionnaire(String assessmentDocId) async {
    QuerySnapshot questionnaireSnapshot = await _questionnaireCollection
        .where('assessment_id',
            isEqualTo:
                FirebaseFirestore.instance.doc('assessment/$assessmentDocId'))
        .get();

    if (questionnaireSnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = questionnaireSnapshot.docs.first;
      return Questionnaire.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

}
