import '../models/profile_match.dart';

class Gender {
  static const String man = 'Man';
  static const String woman = 'Woman';
  static const String other = 'Other';
}

class Interest {
  static const String man = 'Man';
  static const String woman = 'Woman';
  static const String all = 'All';
}

const List<ProfileMatch> profileMatchCombinations = [
  ProfileMatch(Gender.man, Interest.man),
  ProfileMatch(Gender.man, Interest.woman),
  ProfileMatch(Gender.man, Interest.all),
  ProfileMatch(Gender.woman, Interest.man),
  ProfileMatch(Gender.woman, Interest.woman),
  ProfileMatch(Gender.woman, Interest.all),
  ProfileMatch(Gender.other, Interest.man),
  ProfileMatch(Gender.other, Interest.woman),
  ProfileMatch(Gender.other, Interest.all),
];

Iterable<ProfileMatch> getPotentialMatches(String? gender, String? interest) {
  switch (gender) {
    case Gender.man:
      return _getMatchesForMan(interest);
    case Gender.woman:
      return _getMatchesForWoman(interest);
    case Gender.other:
      return _getMatchesForOther(interest);
    default:
      return [];
  }
}

Iterable<ProfileMatch> _getMatchesForMan(String? interest) {
  switch (interest) {
    case Interest.man:
      return _getMatchesForManInterestedInMan();
    case Interest.woman:
      return _getMatchesForManInterestedInWoman();
    case Interest.all:
      return _getMatchesForManInterestedInAll();
    default:
      return [];
  }
}

Iterable<ProfileMatch> _getMatchesForWoman(String? interest) {
  switch (interest) {
    case Interest.man:
      return _getMatchesForWomanInterestedInMan();
    case Interest.woman:
      return _getMatchesForWomanInterestedInWoman();
    case Interest.all:
      return _getMatchesForWomanInterestedInAll();
    default:
      return [];
  }
}

Iterable<ProfileMatch> _getMatchesForOther(String? interest) {
  switch (interest) {
    case Interest.man:
      return _getMatchesForOtherInterestedInMan();
    case Interest.woman:
      return _getMatchesForOtherInterestedInWoman();
    case Interest.all:
      return _getMatchesForOtherInterestedInAll();
    default:
      return [];
  }
}

Iterable<ProfileMatch> _getMatchesForManInterestedInMan() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.man &&
      [Interest.man, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForManInterestedInWoman() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.woman &&
      [Interest.man, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForManInterestedInAll() {
  return profileMatchCombinations
      .where((match) => [Interest.man, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForWomanInterestedInMan() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.man &&
      [Interest.woman, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForWomanInterestedInWoman() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.woman &&
      [Interest.woman, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForWomanInterestedInAll() {
  return profileMatchCombinations.where(
      (match) => [Interest.woman, Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForOtherInterestedInMan() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.man && [Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForOtherInterestedInWoman() {
  return profileMatchCombinations.where((match) =>
      match.gender == Gender.woman && [Interest.all].contains(match.interest));
}

Iterable<ProfileMatch> _getMatchesForOtherInterestedInAll() {
  return profileMatchCombinations
      .where((match) => [Interest.all].contains(match.interest));
}
