part of global;

 class AssessmentEvent extends Equatable {
  const AssessmentEvent();

  @override
  List<Object> get props => [];
}

class StartAssessment extends AssessmentEvent{
  final Assessment assessment;
  final String selectedPatientId;
  final String questionOneValue;
  final String questionTwoValue;
  final String questionThreeValue;
  final String questionFourValue;
  const StartAssessment(
     this.assessment,
     this.selectedPatientId,
     this.questionOneValue,
     this.questionTwoValue,
     this.questionThreeValue,
     this.questionFourValue,
  );
  @override
  List<Object> get props => [
    assessment,
    selectedPatientId,
    questionOneValue,
    questionTwoValue,
    questionThreeValue,
    questionFourValue,
    ];
}
class LoadAssessment extends AssessmentEvent{}
class ResetState extends AssessmentEvent{}
class LoadRecentAssessment extends AssessmentEvent{}
class LoadAssessmentType extends AssessmentEvent{}
class RefreshAssessment extends AssessmentEvent{
  final List<Map<String, dynamic>> assessments;
  const RefreshAssessment(
     this.assessments,
  );
  @override
  List<Object> get props => [assessments];
}

class RefreshRecentAssessment extends AssessmentEvent{
  final List<Map<String, dynamic>> assessments;
  const RefreshRecentAssessment(
     this.assessments,
  );
  @override
  List<Object> get props => [assessments];
}
class RefreshAssessmentType extends AssessmentEvent{
  final List<AssessmentType> assessmentType;
  const RefreshAssessmentType(
     this.assessmentType,
  );
  @override
  List<Object> get props => [assessmentType];
}
// class StartAssessment extends AssessmentEvent{}