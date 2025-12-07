
bool isCompatibleBlood(String donorBlood, String neederBlood) {
  donorBlood = donorBlood.toUpperCase();
  neederBlood = neederBlood.toUpperCase();

  switch (neederBlood) {
    case 'A+':
      return ['A+', 'A-', 'O+', 'O-'].contains(donorBlood);
    case 'A-':
      return ['A-', 'O-'].contains(donorBlood);
    case 'B+':
      return ['B+', 'B-', 'O+', 'O-'].contains(donorBlood);
    case 'B-':
      return ['B-', 'O-'].contains(donorBlood);
    case 'AB+':
      return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].contains(donorBlood);
    case 'AB-':
      return ['A-', 'B-', 'AB-', 'O-'].contains(donorBlood);
    case 'O+':
      return ['O+', 'O-'].contains(donorBlood);
    case 'O-':
      return donorBlood == 'O-';
    default:
      return false;
  }
}
