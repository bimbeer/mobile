import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../app/bloc/app_bloc.dart';
import '../bloc/personal_info_bloc.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<PersonalInfoBloc>()
        .add(PersonalInfoLoaded(context.read<AppBloc>().state.profile));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UsernameInput(),
        const SizedBox(
          height: 20,
        ),
        _FirstNameInput(),
        const SizedBox(
          height: 20,
        ),
        _SecondNameInput(),
        const SizedBox(
          height: 20,
        ),
        _AgeInput(),
        const SizedBox(
          height: 20,
        ),
        _DescriptionInput(),
        const SizedBox(
          height: 20,
        ),
        _GenderInput(),
        const SizedBox(
          height: 20,
        ),
        _InterestInput(),
        const SizedBox(
          height: 20,
        ),
        const Center(child: _SavePersonalInfoButton()),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: Text(
          'DISPLAYED NAME',
        ),
      ),
      BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) =>
              previous.username != current.username,
          builder: (context, state) {
            context
                .read<PersonalInfoBloc>()
                .add(UsernameChanged(state.username.value));

            return TextFormField(
              initialValue: state.username.value,
              key: const Key('editProfileForm_usernameInput_textField'),
              onChanged: (value) => {
                context.read<PersonalInfoBloc>().add(UsernameChanged(value))
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  errorText: state.username.error?.message,
                  contentPadding: const EdgeInsets.only(left: 20),
                  filled: true,),
            );
          })
    ]);
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: Text(
          'FIRST NAME',
        ),
      ),
      BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) =>
              previous.firstName != current.firstName,
          builder: (context, state) {
            context
                .read<PersonalInfoBloc>()
                .add(FirstNameChanged(state.firstName.value));

            return TextFormField(
              initialValue: state.firstName.value,
              key: const Key('editProfileForm_firstNameInput_textField'),
              onChanged: (value) => {
                context.read<PersonalInfoBloc>().add(FirstNameChanged(value))
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  errorText: state.firstName.error?.message,
                  contentPadding: const EdgeInsets.only(left: 20),
                  filled: true,),
            );
          })
    ]);
  }
}

class _SecondNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: Text(
          'SECOND NAME',
        ),
      ),
      BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) =>
              previous.lastName != current.lastName,
          builder: (context, state) {
            context
                .read<PersonalInfoBloc>()
                .add(LastNameChanged(state.lastName.value));

            return TextFormField(
              initialValue: state.lastName.value,
              key: const Key('editProfileForm_secondNameInput_textField'),
              onChanged: (value) => {
                context.read<PersonalInfoBloc>().add(LastNameChanged(value))
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  errorText: state.lastName.error?.message,
                  contentPadding: const EdgeInsets.only(left: 20),
                  filled: true,),
            );
          })
    ]);
  }
}

class _AgeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('AGE'),
        ),
        BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) => previous.age != current.age,
          builder: (context, state) {
            return TextFormField(
              controller:
                  TextEditingController(text: state.age.value.toString()),
              key: const Key('editProfileForm_ageInput_textField'),
              readOnly: true,
              onTap: () {
                agePickerModal(context);
              },
              decoration: InputDecoration(
                errorText: state.age.error?.message,
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> agePickerModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                const Text('SELECT AGE'),
                Expanded(
                  child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                    buildWhen: (previous, current) =>
                        previous.age != current.age,
                    builder: (context, state) {
                      return NumberPicker(
                        value: state.age.value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) => {
                          context
                              .read<PersonalInfoBloc>()
                              .add(AgeChanged(value))
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: Text(
          'ABOUT ME',
        ),
      ),
      BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) =>
              previous.description != current.description,
          builder: (context, state) {
            context
                .read<PersonalInfoBloc>()
                .add(DescriptionChanged(state.description.value));

            return TextFormField(
              initialValue: state.description.value,
              key: const Key('editProfileForm_descriptionInput_textField'),
              onChanged: (value) => {
                context.read<PersonalInfoBloc>().add(DescriptionChanged(value))
              },
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                  errorText: state.description.error?.message,
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,),
            );
          })
    ]);
  }
}

class _GenderInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('GENDER'),
        ),
        BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) => previous.gender != current.gender,
          builder: (context, state) {
            return TextFormField(
              controller: TextEditingController(text: state.gender.value),
              key: const Key('editProfileForm_genderInput_textField'),
              readOnly: true,
              onTap: () {
                genderPickerModal(context);
              },
              decoration: InputDecoration(
                errorText: state.gender.error?.message,
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> genderPickerModal(BuildContext context) {
    String numberToGender(String value) {
      switch (value) {
        case '0':
          return 'Male';
        case '1':
          return 'Female';
        case '2':
          return 'Other';
        default:
          return 'Male';
      }
    }

    int genderToNumber(String value) {
      switch (value) {
        case 'Male':
          return 0;
        case 'Female':
          return 1;
        case 'Other':
          return 2;
        default:
          return 0;
      }
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                const Text('SELECT GENDER'),
                Expanded(
                  child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                    buildWhen: (previous, current) =>
                        previous.gender != current.gender,
                    builder: (context, state) {
                      return NumberPicker(
                        value: genderToNumber(state.gender.value),
                        minValue: 0,
                        maxValue: 2,
                        textMapper: (numberText) => numberToGender(numberText),
                        onChanged: (value) => {
                          context
                              .read<PersonalInfoBloc>()
                              .add(GenderChanged(numberToGender(value.toString())))
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InterestInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('INTEREST'),
        ),
        BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          buildWhen: (previous, current) => previous.interest != current.interest,
          builder: (context, state) {
            return TextFormField(
              controller: TextEditingController(text: state.interest.value),
              key: const Key('editProfileForm_interestInput_textField'),
              readOnly: true,
              onTap: () {
                interestPickerModal(context);
              },
              decoration: InputDecoration(
                errorText: state.interest.error?.message,
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> interestPickerModal(BuildContext context) {
    String numberToInterest(String value) {
      switch (value) {
        case '0':
          return 'Man';
        case '1':
          return 'Woman';
        case '2':
          return 'All';
        default:
          return 'Man';
      }
    }

    int interestToNumber(String value) {
      switch (value) {
        case 'Man':
          return 0;
        case 'Woman':
          return 1;
        case 'All':
          return 2;
        default:
          return 0;
      }
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                const Text('SELECT PREFERENCE'),
                Expanded(
                  child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                    buildWhen: (previous, current) =>
                        previous.interest != current.interest,
                    builder: (context, state) {
                      return NumberPicker(
                        value: interestToNumber(state.interest.value),
                        minValue: 0,
                        maxValue: 2,
                        textMapper: (numberText) => numberToInterest(numberText),
                        onChanged: (value) => {
                          context
                              .read<PersonalInfoBloc>()
                              .add(InterestChanged(numberToInterest(value.toString())))
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SavePersonalInfoButton extends StatelessWidget {
  const _SavePersonalInfoButton();

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      side: MaterialStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      )),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return Theme.of(context).colorScheme.primary;
        }
        return null;
      }),
    );

    return SizedBox(
      width: 300,
      child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          return ElevatedButton(
            key: const Key('personalInfoForm_save_elevatedButton'),
            onPressed: () {
              final userId = context.read<AppBloc>().state.user.id;
              context
                  .read<PersonalInfoBloc>()
                  .add(FormSubmitted(userId: userId));
            },
            style: buttonStyle,
            child: Stack(
              children: const [
                Align(
                  heightFactor: 1.5,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.save),
                ),
                Center(
                  heightFactor: 1.5,
                  child: Text(
                    'Save Changes',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
