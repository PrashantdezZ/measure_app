part of global;

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  String? selectedApplicableMeasure;
  String? selectedCognitionStatus;
  String? selectedPatientName;

  String? selectedPatientId;
  final FirestoreService _firestoreService;

  AssessmentBloc(this._firestoreService) : super(AssessmentInitial()) {
    on<LoadAssessment>((event, emit) async {
      try {
        emit(AssessmentLoading());
        final assessment =
            await _firestoreService.getAssessmentsWithPatients(true).first;
        add(RefreshAssessment(assessment.toList()));
      } catch (e) {
        emit(const AssessmentFailed('Failed to load todos.'));
      }
    });
    on<RefreshAssessment>((event, emit) async {
      emit(AssessmentLoaded(event.assessments));
    });
   
    on<LoadAssessmentType>((event, emit) async {
      try {
        emit(AssessmentLoading());
        final assessmentType =
            await _firestoreService.getAssessmentType().first;
        print(assessmentType.toString());
        add(RefreshAssessmentType(assessmentType.toList()));
      } catch (e) {
        emit(AssessmentFailed(e.toString()));
      }
    });
    on<RefreshAssessmentType>((event, emit) async {
      emit(AssessmentTypeLoaded(event.assessmentType));
    });
    on<ResetState>((event, emit) async {
      emit(AssessmentInitial());
    });
    on<StartAssessment>((event, emit) async {
      try {
        emit(AssessmentStarted());
        final assessmentType = await _firestoreService.addAssessment(
            event.assessment,
            event.selectedPatientId,
            event.questionOneValue,
            event.questionTwoValue,
            event.questionThreeValue,
            event.questionFourValue);
        emit(AssessmentCompleted());
        // emit(AssessmentInitial());
        add(LoadAssessment());
      } catch (e) {
        emit(AssessmentFailed(e.toString()));
      }
    });
    
  }
}
