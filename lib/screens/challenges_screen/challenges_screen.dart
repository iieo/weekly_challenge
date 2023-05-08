import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/screens/challenges_screen/components/add_challenge_fab.dart';
import 'package:weekly_challenge/screens/challenges_screen/components/challenge_card.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/screens/screen_container.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Challenge> challenges =
        context.watch<FirestoreHandler>().challenges;
    final List<Challenge> challengesCompleted =
        challenges.where((element) => element.isCompleted).toList();
    final List<Challenge> challengesNotCompleted =
        challenges.where((element) => !element.isCompleted).toList();

    return DefaultTabController(
        length: 2,
        child: ScreenContainer(
            title: "Challenges",
            isScrollEnabled: false,
            floatingActionButton: const AddChallengeFab(),
            children: [
              TabBar(
                labelColor: Theme.of(context).colorScheme.onPrimary,
                controller: _tabController,
                tabs: [
                  Tab(
                      text: 'Challenges',
                      icon: Icon(Icons.list,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  Tab(
                      text: 'Completed',
                      icon: Icon(Icons.done,
                          color: Theme.of(context).colorScheme.onPrimary)),
                ],
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  Column(children: [
                    Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            itemCount: challengesNotCompleted.length,
                            itemBuilder: (context, index) {
                              return ChallengeCard(
                                  challenge: challengesNotCompleted[index]);
                            })),
                    const SizedBox(height: 70)
                  ]),
                  Column(children: [
                    Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            itemCount: challengesCompleted.length,
                            itemBuilder: (context, index) {
                              return ChallengeCard(
                                  challenge: challengesCompleted[index]);
                            })),
                    const SizedBox(height: App.defaultBoxMargin * 4),
                  ]),
                ],
              ))
            ]));
  }
}
