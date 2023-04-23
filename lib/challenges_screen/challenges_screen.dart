import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/challenges_screen/components/add_challenge_fab.dart';
import 'package:weekly_challenge/challenges_screen/components/challenge_card.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';

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
        child: Scaffold(
            floatingActionButton: const AddChallengeFloatingButton(),
            appBar: AppBar(
              title: Text('Challenges',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            body: Hero(
                tag: 'challenges',
                child: Container(
                    padding: App.defaultPadding,
                    child: Column(children: [
                      TabBar(
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        controller: _tabController,
                        tabs: [
                          Tab(
                              text: 'Challenges',
                              icon: Icon(Icons.list,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                          Tab(
                              text: 'Completed',
                              icon: Icon(Icons.done,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ],
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView.builder(
                              itemCount: challengesNotCompleted.length,
                              itemBuilder: (context, index) {
                                return ChallengeCard(
                                    challenge: challengesNotCompleted[index]);
                              }),
                          ListView.builder(
                              itemCount: challengesCompleted.length,
                              itemBuilder: (context, index) {
                                return ChallengeCard(
                                    challenge: challengesCompleted[index]);
                              }),
                        ],
                      ))
                    ])))));
  }
}
