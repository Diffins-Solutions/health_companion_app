import 'package:survey_kit/survey_kit.dart';

class Quessionaire {
  static Future<Task> getQuessionaire() {
    final List<String> questions = [
      "I found it hard to wind down",
      "I was aware of dryness of my mouth",
      "I couldn't seem to experience any positive feeling at all",
      "I experienced breathing difficulty (eg: excessively rapid breathing, breathlessness in the absence of physical exertion)",
      "I found it difficult to work up the initiative to do things",
      "I tended to over-react to situations",
      "I experienced trembling (eg: in the hands)",
      "I felt that I was using a lot of nervous energy",
      "I was worried about situations in which I might panic and make a fool of myself",
      "I felt that I have nothing to look forward to",
      "I found myself getting agitated",
      "I found it difficult to relax",
      "I found down-hearted and blue",
      "I was intolerant of anything that kept me from getting on with what I was doing",
      "I felt I was close to panic",
      "I was unable to become enthusiastic about anything",
      "I felt I wasn't worth much as a person",
      "I felt that I was rather touchy",
      "I was aware of the action of my heart in the absence physical-exertion (eg: sense of heart rate increase, heart missing beat)",
      "I felt scared without any good reason",
      "I felt that life was meaningless"
    ];

    List<Step> steps = [
      InstructionStep(
        title:
            'A Guide To Depression, Anxiety and\n Stress Scale \n(DASS 21) \n\nBy Fernando Gomez - Consultant Clinical Psychologist',
        text:
            'The DASS 21 is a 21 item self report questionnaire designed to measure the severity of a range of symptoms common to both'
            'Depression and Anxiety. In completing DASS, the invidual is required to indicate the symptom over the previous week. Each item'
            'is scored from zero(didn\'t apply to me at all over the last week) to 3(applied to me very much or most of the time over the past week).',
        buttonText: 'Let\'s go!',
      )
    ];
    for (String question in questions) {
      steps.add(
        QuestionStep(
          title: '',
          text: question,
          isOptional: false,
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: <TextChoice>[
              TextChoice(text: 'Never', value: '0'),
              TextChoice(text: 'Sometimes', value: '1'),
              TextChoice(text: 'Often', value: '2'),
              TextChoice(text: 'Almost Always', value: '3'),
            ],
            defaultSelection: TextChoice(text: 'Never', value: '0'),
          ),
        ),
      );
    }
    steps.add(
      CompletionStep(
        stepIdentifier: StepIdentifier(id: '321'),
        text: 'Thanks for taking the survey, we will contact you soon!',
        title: 'Done!',
        buttonText: 'Submit survey',
      ),
    );
    final NavigableTask task =
        NavigableTask(id: TaskIdentifier(), steps: steps);
    return Future<Task>.value(task);
  }

  static List<List<bool>> getAnswers() {
    return [
      [true, true, false],
      [true, false, true],
      [false, true, true],
      [true, false, true],
      [false, true, true],
      [true, true, false],
      [true, false, true],
      [true, true, false],
      [true, false, true],
      [false, true, true],
      [true, true, false],
      [true, true, false],
      [false, true, true],
      [true, true, false],
      [true, false, true],
      [false, true, true],
      [false, true, true],
      [true, true, false],
      [true, false, true],
      [true, false, true],
      [false, true, true],
    ];
  }

  static List<String> _getSeverityNames() {
    return ["Normal", "Mild", "Moderate", "Severe", "Extremely Severe"];
  }

  static List<List<int>>? _getSingleScoringScheme(String condition) {
    Map<String, List<List<int>>> scheme = {
      "Depression": [
        [0, 9],
        [10, 13],
        [14, 20],
        [21 - 27],
        [28]
      ],
      "Anxiety": [
        [0, 7],
        [8, 9],
        [10, 14],
        [15, 19],
        [20]
      ],
      "Stress": [
        [0, 14],
        [15, 18],
        [19, 25],
        [26, 33],
        [34]
      ]
    };

    return scheme[condition];
  }

  static String getScoringResult(String condition, int score) {
    List<List<int>>? sceheme = _getSingleScoringScheme(condition);

    if (score > sceheme![sceheme.length - 1][0]) {
      return _getSeverityNames()[sceheme.length - 1];
    }

    for (var i = 0; i < sceheme.length; i++) {
      if (score >= sceheme[i][0] && score <= sceheme[i][1]) {
        return _getSeverityNames()[i];
      }
    }
    return "";
  }
}
