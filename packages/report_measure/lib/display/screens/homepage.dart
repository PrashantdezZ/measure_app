part of report_measure;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late AssessmentBloc _assessmentBloc;

  @override
  void initState() {
    super.initState();
    _assessmentBloc = AssessmentBloc(FirestoreService())..add(LoadAssessment());
  }

  Future<void> _refreshAssessments() async {
    _assessmentBloc.add(LoadAssessment());
  }
  @override
  Widget build(BuildContext context) {
    var bloc = context.read<AssessmentBloc>();
    return BlocProvider(
      create: (context) =>_assessmentBloc,
      child: Container(
          color: kBg,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: kBg,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GradientShadowContainer(
              onTap: () async {
                bloc.add(ResetState());
                final result = await context.push(Routes.newAssessment);
                if (result == true) {
                   _refreshAssessments();
                }
              },
              text: "+New assessment",
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<AssessmentBloc>().add(LoadAssessment());
                return;
              },
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const HomePageHeader(),
                    sizedBoxHeight(38),
                    HeadingWithSeeMore(
                      heading: "Recent History",
                      onTap: () {},
                    ),
                    BlocBuilder<AssessmentBloc, AssessmentState>(
                      // buildWhen: (previous, current) {
                      //   if(previous )
                      // },
                      builder: (context, state) {
                        print(state);
                        if (state is AssessmentLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is AssessmentLoaded) {
                          if (state.assessments.isEmpty) {
                            Center(
                              child: BoldText("No history found", 14, kBlack),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return sizedBoxHeight(12);
                            },
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.assessments.length > 3
                                ? 3
                                : state.assessments.length,
                            itemBuilder: (context, index) {
                              final assessmentData = state.assessments[index];
                              final Assessment assessment =
                                  assessmentData['assessment'];
                              final Patient patient = assessmentData['patient'];

                              return ReportCard(
                                  assessment: assessment, patient: patient);
                            },
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    sizedBoxHeight(30),
                    HeadingWithSeeMore(
                      heading: "Recent Assessments",
                      onTap: () {},
                    ),
                    BlocBuilder<AssessmentBloc, AssessmentState>(
                      builder: (context, state) {
                        // print(state);
                        if (state is AssessmentLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is AssessmentLoaded) {
                          if (state.assessments.isEmpty) {
                            Center(
                              child:
                                  BoldText("No assessments found", 14, kBlack),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return sizedBoxHeight(12);
                            },
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.assessments.length,
                            itemBuilder: (context, index) {
                              final assessmentData = state.assessments[index];
                              final Assessment assessment =
                                  assessmentData['assessment'];

                              return AssessmentCard(
                                assessment: assessment,
                              );
                            },
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    sizedBoxHeight(80)
                  ],
                ),
              )),
            ),
          ))),
    );
  }
}
