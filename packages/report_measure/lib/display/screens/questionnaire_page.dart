// ignore_for_file: public_member_api_docs, sort_constructors_first
part of report_measure;

class QuessionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final AssessmentBloc assessmentBloc;

  const QuessionnairePage(
      {super.key, required this.questionnaire, required this.assessmentBloc});

  @override
  State<QuessionnairePage> createState() => _QuessionnairePageState();
}

class _QuessionnairePageState extends State<QuessionnairePage> {
  late QuestionnaireBloc _bloc;
  int selectedContentIndex = 0;
  int currentIndex = 0;
  @override
  void initState() {
    _bloc = QuestionnaireBloc(FirestoreService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> questionnaires = [
      QuestionOne(
        bloc: _bloc,
        questionOne: widget.questionnaire.questionOne,
      ),
      QuestionTwo(
        bloc: _bloc,
        questionTwo: widget.questionnaire.questionTwo,
      ),
      QuestionThree(
        bloc: _bloc,
        questionThree: widget.questionnaire.questionThree,
      ),
      QuestionFour(
        bloc: _bloc,
        questionFour: widget.questionnaire.questionFour,
      ),
      AssessmentResult(
        assessment: Assessment(
          result: _bloc.totalValueNotifier.value,
          test: {
            'question1': _bloc.questionOneValue ?? "",
            'question2': _bloc.questionTwoValue ?? "",
            'question3': _bloc.questionThreeValue ?? "",
            'question4': _bloc.questionFourValue ?? '',
          },
        ),
      ),
    ];
    forwardNavigation(int index) {
      if (index != questionnaires.length &&
          index != questionnaires.length - 1 &&
          index < questionnaires.length) {
        selectedContentIndex = selectedContentIndex + 1;
        currentIndex = selectedContentIndex;
        if (selectedContentIndex == questionnaires.length - 1) {
          context.read<AssessmentBloc>().add(
                StartAssessment(
                    Assessment(
                      applicableMeasures:
                          widget.assessmentBloc.selectedApplicableMeasure,
                      cognitiveStatus:
                          widget.assessmentBloc.selectedCognitionStatus,
                      result: _bloc.totalValueNotifier.value,
                    ),
                    widget.assessmentBloc.selectedPatientId ?? '',
                    _bloc.questionOneValue ?? "",
                    _bloc.questionTwoValue ?? "",
                    _bloc.questionThreeValue ?? "",
                    _bloc.questionFourValue ?? ""),
              );
        }
      }
      // if (index == 4) {
      //   printToPdf(
      //     context,
      //     Assessment(
      //       result: _bloc.totalValueNotifier.value,
      //       test: {
      //         'question1': _bloc.questionOneValue ?? "",
      //         'question2': _bloc.questionTwoValue ?? "",
      //         'question3': _bloc.questionThreeValue ?? "",
      //         'question4': _bloc.questionFourValue ?? '',
      //       },
      //     ),
      //   );
      // }
      print(index);
      setState(() {});
    }

    backNavigation(int index) {
      if (index != 5 &&
          (index < questionnaires.length && index != 0 && index != -1)) {
        selectedContentIndex = selectedContentIndex - 1;
        currentIndex = selectedContentIndex;
      }
      setState(() {});
    }

    Color indicatorColor(int index) {
      if (index <= currentIndex) {
        return kBlack600;
      } else {
        return kGrey50;
      }
    }

    return PopScope(
      onPopInvoked: (didPop) {
        context.pop();
      },
      child: BlocListener<AssessmentBloc, AssessmentState>(
        listener: (context, state) {
          if (state is AssessmentCompleted) {
            context.read<AssessmentBloc>().add(LoadAssessment());
            _bloc.clear();
          }
        },
        child: Container(
            color: kWhite,
            child: SafeArea(
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedContentIndex >= 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                backNavigation(selectedContentIndex);
                              },
                              child: Container(
                                width: 86,
                                height: 56,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    border:
                                        Border.all(width: 1, color: kGrey400),
                                    color: kWhite),
                                child: SvgPicture.asset(
                                  Assets.icons.back_arrow,
                                  color: kBlack,
                                  height: 23,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Expanded(
                      child: GradientShadowContainer(
                        onTap: () {
                          forwardNavigation(selectedContentIndex);
                        },
                        text: buttonText(selectedContentIndex),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: SvgPicture.asset(
                                Assets.icons.back_arrow,
                                color: kBlack600,
                              ),
                            ),
                            BoldText("Assessment", 16, kBlack600),
                            SvgPicture.asset(
                              Assets.icons.more,
                              color: kBlack600,
                            ),
                          ],
                        ),
                      ),
                      sizedBoxHeight(38),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(questionnaires.length, (index) {
                          return Container(
                            height: 6,
                            margin: const EdgeInsets.only(right: 10),
                            width: 40,
                            decoration: BoxDecoration(
                              color: indicatorColor(index),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 28),
                        child: PageStorage(
                            bucket: PageStorageBucket(),
                            child: questionnaires[selectedContentIndex]),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
