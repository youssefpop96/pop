part of 'on_boarding_cubit.dart';

@immutable
abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {}

class OnBoardingPageChanged extends OnBoardingState {
  final int index;
  OnBoardingPageChanged(this.index);
}
