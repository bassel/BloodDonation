class InfoGroup {
  final int id;
  final String title;
  final List<String> info;

  const InfoGroup({this.id, this.title, this.info});

  static const whoCanDonate = [
    InfoGroup(id: 0, title: 'Blood Donors:', info: _conditions),
    InfoGroup(
      id: 1,
      title: 'You should not donate blood if:',
      info: _doNotDonateIf,
    ),
    InfoGroup(
      id: 2,
      title: 'Wait 6 months before donation if:',
      info: _wait6MonthsIf,
    ),
    InfoGroup(
      id: 3,
      title: 'Wait 12 months before donation:',
      info: _wait12MonthsIf,
    ),
  ];
}

const _conditions = [
  'Must be in good general health',
  'Must be at least 18 years old and no more than 65. After the age of 60, donors require the approval of a transfusion medicine physician',
  'Must weight at least 50 kg',
  'Must not be at risk of transmitting blood-borne diseases',
  '''
Must have a hemoglobin or hematocrit level of:
    o 13.5-18 g/dl (0.40%) for a man
    o 12.5-16 g/dl (0.38%) for a woman
  ''',
  'Must have a systolic blood pressure of 100-140 mmHg and a diastolic blood pressure of 60-90 mmHg',
  'Must have a pulse rate of 60-100 bpm (beats per minute)',
  'Must have a temperature below 37.6°C',
  'Must have a platelet count above 150x109/L',
];

const _doNotDonateIf = [
  'You have ever taken drugs',
  'Your partner takes drugs',
  'You are HIV positive',
  'You are a male who had sexual contacts with another male',
  'Your partner is HIV positive',
  'You have more than one sexual partner',
  'You think your partner has risky sex',
];

const _wait6MonthsIf = [
  'You have casual partners',
  'You have changed sexual partners',
];

const _wait12MonthsIf = [
  'After a tattoo or ear/body piercing',
  'After a scarification (except if therapeutic)',
  'If you have undergone an acupuncture treatment and did not have needles for strictly personal use or single-use needles',
  'If you have been cut with potentially contaminated objects (through sharing razor blades, for example)',
  'If you have had prolonged contact with a damaged skin contaminated with secretions or blood',
  'If you have been injured with a dirty needle',
  'In case of a human bite',
  'After surgery or endoscopic evaluation',
];
