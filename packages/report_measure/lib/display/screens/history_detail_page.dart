part of report_measure;

class AssessmentDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  const AssessmentDetail({super.key, required this.data});

  @override
  State<AssessmentDetail> createState() => _AssessmentDetailState();
}

class _AssessmentDetailState extends State<AssessmentDetail> {
  bool isExpanded = false;

  toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Assessment assessment = widget.data['assessment'];
    final Patient patient = widget.data['patient'];
    return PopScope(
      onPopInvoked: (didPop) => context.pop(),
      child: Scaffold(
        backgroundColor: kBg,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 35, right: 20, left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: SvgPicture.asset(
                            Assets.icons.back_arrow,
                            color: kBlack600,
                          )),
                      ExtraBoldText('History details', 16, kBlack600),
                      const SizedBox.shrink()
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BoldText('ICDO code', 14, kGrey600),
                          BoldText(
                              'Last updated ${formatTimestamp(assessment.updatedAt)}',
                              14,
                              kGrey600),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: screenWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kOrangeBg.withOpacity(.12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExtraBoldText("${assessment.icdo}", 20, kOrange600),
                            sizedBoxHeight(8),
                            MediumText(
                                "${assessment.cognitiveStatus}", 16, kOrange600)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                sizedBoxHeight(18),
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BoldText("Assement Date", 14, kGrey600),
                      BoldText(
                          formatTimestamp(assessment.updatedAt), 14, kGrey600),
                    ],
                  ),
                ),
                sizedBoxHeight(15),
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BoldText('John Smith', 24, kTextPrimary),
                              BoldText('#${assessment.id}', 14, kGrey600),
                            ],
                          ),
                          isExpanded
                              ? GestureDetector(
                                  onTap: () {
                                    toggleExpanded();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 30,
                                    child: SvgPicture.asset(
                                      Assets.icons.arrow_up,
                                    ),
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    toggleExpanded();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 30,
                                    child: SvgPicture.asset(
                                      Assets.icons.arrow_down,
                                    ),
                                  ))
                        ],
                      ),
                      isExpanded
                          ? buildDropDown(patient)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                sizedBoxHeight(20),
                ResultChart(
                  assessment: assessment,
                ),
                sizedBoxHeight(18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropDown(Patient patient) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DecoratedContainerField(
                  "Patient gender", patient.gender ?? '', Assets.icons.male),
            ),
            sizedBoxWidth(12),
            Expanded(
              child: DecoratedContainerField(
                  "Weight", patient.weight.toString(), Assets.icons.weight),
            ),
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       BoldText('Weigth', 14, kGrey600),
            //       Container(
            //         height: 45,
            //         padding: const EdgeInsets.all(10),
            //         width: MediaQuery.of(context).size.width * .43,
            //         decoration: BoxDecoration(
            //             color: Colors.grey.shade200,
            //             borderRadius: BorderRadius.circular(10)),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SvgPicture.asset(Assets.icons.weight),
            //             sizedBoxWidth(10),
            //             MediumText("Male", 16, kTextPrimary),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        sizedBoxHeight(14),
        DecoratedContainerField("Patient date of birth(age)",
            formatTimestamp(patient.dateOfBirth), Assets.icons.bithdate),
        const SizedBox(
          height: 14,
        ),
        DecoratedContainerField("Patient Phone Number",
            patient.phone.toString(), Assets.icons.phone),
        const SizedBox(
          height: 14,
        ),
        DecoratedContainerField(
            "Patient Address", patient.address ?? '', Assets.icons.map),
      ],
    );
  }
}

class DecoratedContainerField extends StatelessWidget {
  final String heading;
  final String name;
  final String icon;
  const DecoratedContainerField(
    this.heading,
    this.name,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BoldText(heading, 14, kGrey600),
        sizedBoxHeight(8),
        Container(
          // width: MediaQuery.of(context).size.width * .43,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(icon),
              sizedBoxWidth(10),
              MediumText(name, 16, kTextPrimary),
            ],
          ),
        ),
      ],
    );
  }
}
