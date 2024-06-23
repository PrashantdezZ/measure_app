part of report_measure;

class NewAssessmentPage extends StatefulWidget {
  Map<String, dynamic>? assessmentType;

  NewAssessmentPage({
    super.key,
    this.assessmentType,
  });

  @override
  State<NewAssessmentPage> createState() => _NewAssessmentPageState();
}

class _NewAssessmentPageState extends State<NewAssessmentPage> {
  late AssessmentBloc assessmentBloc;
  List<Map<String, dynamic>?> patientNames = [];
  String assessment_id = '';
  String selectedPatientName = '';
  @override
  void initState() {
    assessmentBloc = AssessmentBloc(FirestoreService());
    if (widget.assessmentType != null) {
      assessmentBloc.selectedApplicableMeasure =
          widget.assessmentType!['applicableMeasure'];
      assessmentBloc.selectedCognitionStatus =
          widget.assessmentType!['cognitionStatus'];
    }
    super.initState();
  }

  String getPatientIdByName(String patientName) {
    for (var patient in patientNames) {
      if (patient!["name"] == patientName) {
        return patient["id"]!;
      }
    }
    return '';
  }

  validate() {
    if (assessmentBloc.selectedApplicableMeasure != null &&
        assessmentBloc.selectedCognitionStatus != null &&
        patientNames
            .map((e) => e!["name"])
            .contains(assessmentBloc.selectedPatientName)) {
      String id = getPatientIdByName(assessmentBloc.selectedPatientName ?? '');
      assessmentBloc.selectedPatientId = id;
      final testId =
          "${assessmentBloc.selectedCognitionStatus!.toLowerCase()}_${assessmentBloc.selectedApplicableMeasure!.toLowerCase()}";
      assessment_id = "cognition_slums";
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => context.pop(true),
      child: BlocListener<QuestionnaireBloc, QuestionnaireState>(
        listener: (context, state) {
          if (state is QuestionnaireLoading) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is QuestionnaireLoaded) {
            Questionnaire questions = state.questions;
            context.push(Routes.questionnaire, extra: {
              "questions": questions,
              "selectedCognitionStatus": assessmentBloc.selectedCognitionStatus,
              "selectedPatientId": assessmentBloc.selectedPatientId,
              "assessmentBloc": assessmentBloc
            });
          }
          // TODO: implement listener
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: validate()
              ? GradientShadowContainer(
                  onTap: () {
                    context
                        .read<QuestionnaireBloc>()
                        .add(LoadQuestions(assessment_id));
                  },
                  text: "Start assessment",
                )
              : DisabledButton(
                  text: "Start assessment",
                ),
          body: Container(
            color: kBg,
            child: SafeArea(
              child: BlocProvider(
                create: (context) => AssessmentBloc(FirestoreService())
                  ..add(LoadAssessmentType()),
                child: BlocBuilder<AssessmentBloc, AssessmentState>(
                  builder: (context, state) {
                    if (state is AssessmentLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is AssessmentTypeLoaded) {
                      var assessmentType =
                          state.assessmentType[0].cognitiveStatus;
                      var applicableMeasure =
                          state.assessmentType[0].applicableMeasures;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.pop(true);
                                  },
                                  child: SvgPicture.asset(
                                    Assets.icons.back_arrow,
                                    color: kBlack600,
                                  ),
                                ),
                                BoldText("New assessment", 16, kBlack600),
                                const SizedBox.shrink()
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sizedBoxHeight(32),
                                BoldText("Cognitive status", 14, kGrey600),
                                sizedBoxHeight(4),
                                SizedBox(
                                  height: 56,
                                  child: DropdownButtonFormField<String>(
                                    hint: MediumText("Select cognitive status",
                                        16, kGrey600),
                                    icon: SvgPicture.asset(
                                        Assets.icons.arrow_down),
                                    decoration: dropDownDecoration,
                                    value:
                                        assessmentBloc.selectedCognitionStatus,
                                    items: assessmentType.map((status) {
                                      return DropdownMenuItem(
                                        value: status,
                                        child:
                                            MediumText(status, 16, kBlack600),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        assessmentBloc.selectedCognitionStatus =
                                            newValue;
                                        assessmentBloc
                                                .selectedApplicableMeasure =
                                            null; // Reset applicable measures
                                      });
                                    },
                                  ),
                                ),
                                sizedBoxHeight(33),
                                assessmentBloc.selectedCognitionStatus != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BoldText("Applicable measures", 14,
                                              kGrey600),
                                          sizedBoxHeight(4),
                                          SizedBox(
                                            height: 56,
                                            child:
                                                DropdownButtonFormField<String>(
                                              hint: MediumText(
                                                  "select applicable measures",
                                                  16,
                                                  kGrey600),
                                              icon: SvgPicture.asset(
                                                  Assets.icons.arrow_down),
                                              decoration: dropDownDecoration,
                                              value: assessmentBloc
                                                  .selectedApplicableMeasure,
                                              items: assessmentBloc
                                                          .selectedCognitionStatus ==
                                                      null
                                                  ? []
                                                  : applicableMeasure[assessmentBloc
                                                          .selectedCognitionStatus]!
                                                      .map((measure) {
                                                      return DropdownMenuItem(
                                                        value: measure,
                                                        child: MediumText(
                                                            measure,
                                                            16,
                                                            kBlack600),
                                                      );
                                                    }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  assessmentBloc
                                                          .selectedApplicableMeasure =
                                                      newValue;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : const DisabledDropDown(
                                        headingText: "Applicable measures",
                                        hintText: "Select applicable measures",
                                      ),
                                sizedBoxHeight(33),
                                assessmentBloc.selectedApplicableMeasure != null
                                    ? BlocBuilder<UsersBloc, UsersState>(
                                        builder: (context, state) {
                                          if (state is UsersLoading) {
                                            return const SizedBox.shrink();
                                          } else if (state
                                              is UsersLoadedState) {
                                            final patients = state.patients
                                                .map(
                                                  (e) => e.name ?? "",
                                                )
                                                .toList();
                                            patientNames = state.patients
                                                .map((e) => {
                                                      "name": e.name,
                                                      "id": e.id
                                                    })
                                                .toList();
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                BoldText(
                                                    "Patient", 14, kGrey600),
                                                sizedBoxHeight(4),
                                                AutoCompleteTextField(
                                                  patientNames: patients,
                                                  selectedPatientName:
                                                      selectedPatientName,
                                                  onSelected: (String value) {
                                                    setState(() {
                                                      selectedPatientName =
                                                          value;
                                                      assessmentBloc
                                                              .selectedPatientName =
                                                          selectedPatientName;
                                                      validate();
                                                    });
                                                    print(assessmentBloc
                                                        .selectedPatientName);
                                                  },
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      )
                                    : const DisabledDropDown(
                                        headingText: "Patient",
                                        hintText: "Enter patient name or ID"),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is AssessmentFailed) {
                      return Center(
                        child: BoldText(state.message, 22, kTextPrimary),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
